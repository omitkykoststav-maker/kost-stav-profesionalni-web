const crypto = require("crypto");
const net = require("net");
const tls = require("tls");

const THANK_YOU_PATH = "/dekujeme.html";
const DEFAULT_SUBJECT = "Nová poptávka z webu KOST STAV";

module.exports = async function handler(req, res) {
  if (req.method === "OPTIONS") {
    res.setHeader("Allow", "POST, OPTIONS");
    return res.status(204).end();
  }

  if (req.method !== "POST") {
    res.setHeader("Allow", "POST, OPTIONS");
    return res.status(405).json({ ok: false, message: "Method not allowed" });
  }

  try {
    const { fields, files } = await parseRequest(req);

    if (!getFirst(fields, "jmeno") || !getFirst(fields, "telefon")) {
      return res.status(400).json({ ok: false, message: "Missing required contact fields" });
    }

    await sendContactEmail(fields, files);
    return res.status(200).json({ ok: true, redirect: THANK_YOU_PATH });
  } catch (error) {
    console.error("Contact form error:", error);
    return res.status(500).json({ ok: false, message: "Contact form delivery failed" });
  }
};

async function parseRequest(req) {
  const contentType = String(req.headers["content-type"] || "");
  const rawBody = await readBody(req);

  if (contentType.includes("multipart/form-data")) {
    const boundary = getBoundary(contentType);
    if (!boundary) throw new Error("Missing multipart boundary");
    return parseMultipart(rawBody, boundary);
  }

  if (contentType.includes("application/x-www-form-urlencoded")) {
    const fields = {};
    const params = new URLSearchParams(rawBody.toString("utf8"));
    for (const [name, value] of params.entries()) addField(fields, name, value);
    return { fields, files: [] };
  }

  if (contentType.includes("application/json")) {
    const parsed = JSON.parse(rawBody.toString("utf8") || "{}");
    const fields = {};
    for (const [name, value] of Object.entries(parsed)) addField(fields, name, String(value ?? ""));
    return { fields, files: [] };
  }

  return { fields: {}, files: [] };
}

function readBody(req) {
  if (Buffer.isBuffer(req.body)) return Promise.resolve(req.body);
  if (typeof req.body === "string") return Promise.resolve(Buffer.from(req.body, "utf8"));

  const maxBytes = Number(process.env.CONTACT_MAX_UPLOAD_MB || 12) * 1024 * 1024;
  const chunks = [];
  let total = 0;

  return new Promise((resolve, reject) => {
    req.on("data", (chunk) => {
      total += chunk.length;
      if (total > maxBytes) {
        reject(new Error("Request body is too large"));
        req.destroy();
        return;
      }
      chunks.push(chunk);
    });
    req.on("end", () => resolve(Buffer.concat(chunks)));
    req.on("error", reject);
  });
}

function getBoundary(contentType) {
  const match = contentType.match(/boundary=(?:"([^"]+)"|([^;]+))/i);
  return match ? (match[1] || match[2]).trim() : "";
}

function parseMultipart(buffer, boundary) {
  const fields = {};
  const files = [];
  const boundaryBuffer = Buffer.from("--" + boundary);

  for (const rawPart of splitBuffer(buffer, boundaryBuffer)) {
    let part = rawPart;
    if (!part.length) continue;
    if (part.slice(0, 2).toString() === "--") continue;
    if (part.slice(0, 2).toString() === "\r\n") part = part.slice(2);
    if (part.slice(-2).toString() === "\r\n") part = part.slice(0, -2);

    const headerEnd = part.indexOf(Buffer.from("\r\n\r\n"));
    if (headerEnd === -1) continue;

    const headerText = part.slice(0, headerEnd).toString("utf8");
    const body = part.slice(headerEnd + 4);
    const disposition = headerText.match(/content-disposition:\s*([^\r\n]+)/i);
    if (!disposition) continue;

    const nameMatch = disposition[1].match(/name="([^"]+)"/i);
    if (!nameMatch) continue;

    const name = nameMatch[1];
    const filenameMatch = disposition[1].match(/filename="([^"]*)"/i);
    const typeMatch = headerText.match(/content-type:\s*([^\r\n]+)/i);

    if (filenameMatch) {
      const filename = filenameMatch[1];
      if (!filename || !body.length) continue;
      files.push({
        fieldName: name,
        filename,
        contentType: typeMatch ? typeMatch[1].trim() : "application/octet-stream",
        content: body,
      });
    } else {
      addField(fields, name, body.toString("utf8"));
    }
  }

  return { fields, files };
}

function splitBuffer(buffer, separator) {
  const parts = [];
  let start = 0;
  let index = buffer.indexOf(separator, start);

  while (index !== -1) {
    parts.push(buffer.slice(start, index));
    start = index + separator.length;
    index = buffer.indexOf(separator, start);
  }

  parts.push(buffer.slice(start));
  return parts;
}

function addField(fields, name, value) {
  if (!name || name.startsWith("_")) return;
  const text = String(value || "").trim();
  if (!text) return;
  if (!fields[name]) fields[name] = [];
  fields[name].push(text);
}

function getFirst(fields, name) {
  return fields[name] && fields[name][0] ? fields[name][0] : "";
}

async function sendContactEmail(fields, files) {
  const config = getEmailConfig();
  const message = buildEmail(fields, files, config);

  await sendWithResend(message, config.resendApiKey);
}

function getEmailConfig() {
  const resendApiKey = getEnv("RESEND_API_KEY");
  const to = splitRecipients(getEnv("CONTACT_TO"));
  const from = getEnv("CONTACT_FROM");
  const missing = [];

  if (!resendApiKey) missing.push("RESEND_API_KEY");
  if (!to.length) missing.push("CONTACT_TO");
  if (!from) missing.push("CONTACT_FROM");

  if (missing.length) {
    throw new Error("Missing required Vercel env variables: " + missing.join(", "));
  }

  return { resendApiKey, to, from };
}

function getEnv(name) {
  return String(process.env[name] || "").trim();
}

function splitRecipients(value) {
  return String(value || "")
    .split(",")
    .map((email) => email.trim())
    .filter(Boolean);
}

function buildEmail(fields, files, config) {
  const text = buildTextBody(fields, files, config.to.join(", "));
  const replyTo = getFirst(fields, "email");
  const subject = DEFAULT_SUBJECT;

  return { from: config.from, to: config.to, subject, text, replyTo, files };
}

function buildTextBody(fields, files, recipientText) {
  const labels = {
    jmeno: "Jméno a příjmení",
    telefon: "Telefon",
    email: "E-mail",
    adresa_stavby: "Adresa stavby / obec",
    typ_prace: "Typ práce",
    "typ_omitky[]": "Typ omítky",
    "typ_fasady[]": "Typ fasády",
    stav_objektu: "Stav objektu",
    plocha: "Přibližná plocha v m2",
    termin: "Požadovaný termín",
    popis: "Popis zakázky",
    souhlas: "Souhlas",
  };

  const lines = [
    "Nová poptávka z webu KOST STAV",
    "",
    "Cílový e-mail: " + recipientText,
    "",
  ];

  for (const [name, values] of Object.entries(fields)) {
    const label = labels[name] || name.replace(/\[\]$/, "").replace(/_/g, " ");
    lines.push(label + ": " + values.join(", "));
  }

  if (files.length) {
    lines.push("", "Prilohy:");
    for (const file of files) {
      lines.push("- " + file.filename + " (" + file.contentType + ", " + file.content.length + " B)");
    }
  }

  return lines.join("\n");
}

async function sendWithResend(message, apiKey) {
  const attachments = message.files.map((file) => ({
    filename: file.filename,
    content: file.content.toString("base64"),
  }));

  const response = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      Authorization: "Bearer " + apiKey,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      from: message.from,
      to: message.to,
      subject: message.subject,
      text: message.text,
      reply_to: message.replyTo || undefined,
      attachments: attachments.length ? attachments : undefined,
    }),
  });

  if (!response.ok) {
    throw new Error("Resend delivery failed: " + response.status + " " + (await response.text()));
  }
}

async function sendWithSmtp(message) {
  const host = process.env.SMTP_HOST;
  const port = Number(process.env.SMTP_PORT || 587);
  const secure = String(process.env.SMTP_SECURE || "").toLowerCase() === "true" || port === 465;
  const user = process.env.SMTP_USER || "";
  const pass = process.env.SMTP_PASS || "";
  const fromEmail = extractEmail(message.from);
  const toEmail = extractEmail(message.to);
  const mime = buildMimeMessage(message);

  let client = await connectSmtp(host, port, secure);
  await assertSmtp(client.wait(), "SMTP greeting");
  await assertSmtp(client.send("EHLO kost-stav.cz"), "EHLO");

  if (!secure) {
    await assertSmtp(client.send("STARTTLS"), "STARTTLS");
    client = await upgradeToTls(client, host);
    await assertSmtp(client.send("EHLO kost-stav.cz"), "EHLO after STARTTLS");
  }

  if (user && pass) {
    await assertSmtp(client.send("AUTH LOGIN"), "AUTH LOGIN");
    await assertSmtp(client.send(Buffer.from(user).toString("base64")), "SMTP username");
    await assertSmtp(client.send(Buffer.from(pass).toString("base64")), "SMTP password");
  }

  await assertSmtp(client.send("MAIL FROM:<" + fromEmail + ">"), "MAIL FROM");
  await assertSmtp(client.send("RCPT TO:<" + toEmail + ">"), "RCPT TO");
  await assertSmtp(client.send("DATA"), "DATA");
  await assertSmtp(client.sendData(mime), "message body");
  await client.send("QUIT").catch(() => null);
  client.close();
}

function connectSmtp(host, port, secure) {
  const socket = secure
    ? tls.connect({ host, port, servername: host })
    : net.connect({ host, port });
  return Promise.resolve(createSmtpClient(socket));
}

async function upgradeToTls(client, host) {
  const oldSocket = client.socket;
  oldSocket.removeAllListeners("data");
  const secureSocket = tls.connect({ socket: oldSocket, servername: host });
  await new Promise((resolve, reject) => {
    secureSocket.once("secureConnect", resolve);
    secureSocket.once("error", reject);
  });
  return createSmtpClient(secureSocket);
}

function createSmtpClient(socket) {
  const pending = [];
  let buffer = "";

  socket.on("data", (chunk) => {
    buffer += chunk.toString("utf8");
    let index = buffer.indexOf("\n");
    while (index !== -1) {
      const line = buffer.slice(0, index).replace(/\r$/, "");
      buffer = buffer.slice(index + 1);
      const current = pending[0];
      if (current) {
        current.lines.push(line);
        if (/^\d{3} /.test(line)) {
          pending.shift();
          current.resolve(current.lines);
        }
      }
      index = buffer.indexOf("\n");
    }
  });

  socket.on("error", (error) => {
    while (pending.length) pending.shift().reject(error);
  });

  const wait = () => new Promise((resolve, reject) => pending.push({ resolve, reject, lines: [] }));

  return {
    socket,
    wait,
    send(command) {
      const response = wait();
      socket.write(command + "\r\n");
      return response;
    },
    sendData(data) {
      const response = wait();
      socket.write(data.replace(/\r?\n/g, "\r\n") + "\r\n.\r\n");
      return response;
    },
    close() {
      socket.end();
    },
  };
}

async function assertSmtp(responsePromise, label) {
  const lines = await responsePromise;
  const last = lines[lines.length - 1] || "";
  const code = Number(last.slice(0, 3));
  if (code >= 400 || !code) {
    throw new Error(label + " failed: " + lines.join(" | "));
  }
  return lines;
}

function buildMimeMessage(message) {
  const boundary = "----koststav-" + crypto.randomBytes(12).toString("hex");
  const headers = [
    "From: " + sanitizeHeader(message.from),
    "To: " + sanitizeHeader(message.to),
    "Subject: " + encodeHeader(message.subject),
    "Date: " + new Date().toUTCString(),
    "Message-ID: <" + crypto.randomBytes(16).toString("hex") + "@kost-stav.cz>",
    "MIME-Version: 1.0",
    'Content-Type: multipart/mixed; boundary="' + boundary + '"',
  ];

  if (message.replyTo && /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(message.replyTo)) {
    headers.splice(2, 0, "Reply-To: " + sanitizeHeader(message.replyTo));
  }

  const parts = [
    "--" + boundary,
    'Content-Type: text/plain; charset="UTF-8"',
    "Content-Transfer-Encoding: base64",
    "",
    wrapBase64(Buffer.from(message.text, "utf8").toString("base64")),
  ];

  for (const file of message.files) {
    parts.push(
      "--" + boundary,
      'Content-Type: ' + sanitizeHeader(file.contentType) + '; name="' + sanitizeHeader(file.filename) + '"',
      "Content-Transfer-Encoding: base64",
      'Content-Disposition: attachment; filename="' + sanitizeHeader(file.filename) + '"',
      "",
      wrapBase64(file.content.toString("base64"))
    );
  }

  parts.push("--" + boundary + "--", "");
  return headers.join("\r\n") + "\r\n\r\n" + parts.join("\r\n");
}

function encodeHeader(value) {
  return "=?UTF-8?B?" + Buffer.from(value, "utf8").toString("base64") + "?=";
}

function sanitizeHeader(value) {
  return String(value || "").replace(/[\r\n"]/g, "");
}

function wrapBase64(value) {
  return value.replace(/.{1,76}/g, "$&\r\n").trim();
}

function extractEmail(value) {
  const text = String(value || "");
  const match = text.match(/<([^>]+)>/);
  return (match ? match[1] : text).trim();
}
