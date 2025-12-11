
# Finanzielle Möglichkeit – Produktions-Setup

Dieses Repository ist für **Produktivbetrieb** vorbereitet:

- Flutter App (Branding Schwarz/Orange, Claim: "Du möchtest dich verändern?")
- Node.js Backend (Express + WebSocket-Chat)
- API-Absicherung mit API-Key
- Build mit `--dart-define` (API-Key nicht im Code)
- Obfuskation & Split-Debug-Info für Android-Release
- CI-Workflow (GitHub Actions) vorbereitet für Secrets

## Strukur

- `app/` – Flutter App
- `backend/` – Backend (Express + WS-Chat)
- `.github/workflows/` – CI
- `scripts/` – Build-Skripte

## WICHTIG – API-Key

Aktueller API-Key (nur als Beispiel, bitte in Produktion ändern):

`0ZShFcccONpjFyYyKwqPLVBaR3TmTVIYBVotDxZh8L3AGSGD`

### Backend (.env)

In `backend/.env`:

```env
PORT=5000
API_KEY=0ZShFcccONpjFyYyKwqPLVBaR3TmTVIYBVotDxZh8L3AGSGD
FRONTEND_ORIGIN=http://localhost:5000
```

### Flutter Build

Beim Build MUSS der Key per `--dart-define` gesetzt werden:

```bash
cd app
flutter build apk --release --dart-define=API_KEY=0ZShFcccONpjFyYyKwqPLVBaR3TmTVIYBVotDxZh8L3AGSGD --obfuscate --split-debug-info=../output/debug_info
```

## Schnellstart (lokal)

### Backend

```bash
cd backend
cp .env.example .env
npm install
npm start
```

### Flutter

```bash
cd app
flutter pub get
flutter run --dart-define=API_KEY=0ZShFcccONpjFyYyKwqPLVBaR3TmTVIYBVotDxZh8L3AGSGD
```
# Trigger CI
Test Commit um Workflow auszuführen



