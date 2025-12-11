
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import http from 'http';
import { WebSocketServer } from 'ws';
import helmet from 'helmet';
import morgan from 'morgan';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// Security Headers
app.use(helmet({
  contentSecurityPolicy: false, // für APIs nicht zwingend
}));

// Logging (nur minimal in Produktion)
if (process.env.NODE_ENV === 'production') {
  const logDir = path.join(__dirname, '..', 'logs');
  if (!fs.existsSync(logDir)) fs.mkdirSync(logDir);
  const accessLogStream = fs.createWriteStream(
    path.join(logDir, 'access.log'),
    { flags: 'a' }
  );
  app.use(morgan('combined', { stream: accessLogStream }));
} else {
  app.use(morgan('dev'));
}

// CORS - nur erlaubte Origin
const allowedOrigin = process.env.FRONTEND_ORIGIN || 'http://localhost:5000';
app.use(
  cors({
    origin: allowedOrigin,
    credentials: false,
  })
);

app.use(express.json());

// API-Key Middleware
app.use((req, res, next) => {
  const headerKey = req.headers['x-api-key'];
  const globalKey = process.env.API_KEY;

  if (!globalKey) {
    console.warn('WARNUNG: Kein API_KEY in .env gesetzt – alle Requests erlaubt!');
    return next();
  }

  if (!headerKey) {
    return res.status(401).json({ error: 'API-Key fehlt' });
  }

  if (headerKey !== globalKey) {
    return res.status(403).json({ error: 'API-Key ungültig' });
  }

  next();
});

// In-Memory Leads
const leads = [];
app.post('/api/leads', (req, res) => {
  const { name, email, ziel } = req.body;
  if (!name || !email) {
    return res.status(400).json({ error: 'Name und E-Mail erforderlich' });
  }
  const lead = { id: leads.length + 1, name, email, ziel, createdAt: new Date() };
  leads.push(lead);
  res.json({ success: true, lead });
});

// Produkte (statisch)
const products = [
  { _id: 'p1', title: 'E-Book: Geld verstehen', description: 'Die Grundlagen von Geld, Schulden und Vermögensaufbau.', price: 19.99 },
  { _id: 'p2', title: 'Mini-Kurs: Budget-Reset', description: 'In 7 Tagen zu einem klaren Plan für deine Finanzen.', price: 49.0 },
  { _id: 'p3', title: 'Vorlagen-Paket', description: 'Budget-Tracker, Sparplan, Schulden-Tracker als PDF/Excel.', price: 29.0 },
];

app.get('/api/products', (req, res) => {
  res.json(products);
});

// Checkout (Platzhalter, später Stripe/PayPal etc.)
app.post('/api/checkout', (req, res) => {
  const { productId, method } = req.body;
  const product = products.find((p) => p._id === productId);
  if (!product) return res.status(404).json({ error: 'Produkt nicht gefunden' });
  res.json({
    success: true,
    message: `Zahlung (${method}) für ${product.title} wurde simuliert.`,
  });
});

app.get('/', (req, res) => {
  res.send('Finanzielle Möglichkeit Backend läuft');
});

const server = http.createServer(app);

// WebSocket Chat
const wss = new WebSocketServer({ server, path: '/ws/chat' });

wss.on('connection', (ws) => {
  ws.send('Willkommen im Support-Chat!');

  ws.on('message', (message) => {
    const text = message.toString();
    // In Produktion hier keine sensiblen Daten loggen
    ws.send('Echo: ' + text);
  });
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log('Backend läuft auf Port ' + PORT);
});
