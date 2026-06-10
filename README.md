# QuickSlot 🏸⚽

> Mini app to book sports slots (badminton/turf) — concurrency-safe booking, Flutter + GetX frontend, Node.js + Supabase backend.

---

## Setup Steps

### Backend (Node.js)

```bash
cd server
npm install
```

Create a `.env` file in `/server`:

```dotenv
DATABASE_URL="postgresql://postgres:YOUR_PASSWORD@db.YOUR_REF.supabase.co:5432/postgres"
PORT=3000
```

> **Note:** URL-encode special characters in password — `@` → `%40`, `#` → `%23`

```bash
node index.js
# Server running on port 3000
```

---

### Frontend (Flutter)

```bash
cd quickslot_app
flutter pub get
flutter run
```

---

## Architecture

### Backend
- **Runtime:** Node.js + Express
- **Database:** PostgreSQL via Supabase
- **Auth:** Lightweight — hardcoded users, `X-User-Id` header

### Database Schema

| Table | Key Columns |
|-------|------------|
| `venues` | id, name, sport, location |
| `slots` | id, venue_id, date, start_time, end_time, status |
| `bookings` | id, slot_id, user_id, created_at |
| `users` | id, name |

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/venues` | List all venues |
| GET | `/venues/:id` | Venue detail |
| GET | `/venues/:id/slots?date=YYYY-MM-DD` | Slots for a date |
| POST | `/bookings` | Book a slot (concurrency-safe) |
| GET | `/users/:id/bookings` | User's bookings |
| DELETE | `/bookings/:id` | Cancel a booking |

### Flutter (GetX)
```
lib/
├── app/
│   ├── bindings/
│   └── routes/
├── data/
│   ├── models/
│   └── providers/
├── modules/
│   ├── auth/
│   ├── venues/
│   ├── slots/
│   └── bookings/
├── widgets/
└── main.dart
```

- **State Management:** GetX — chosen for minimal boilerplate, built-in routing, and reactive state in a time-constrained hackathon setting
- **HTTP:** Dio

---

## Concurrency Approach

Slot booking uses a PostgreSQL transaction with a row-level lock to prevent double booking:

```sql
BEGIN;
SELECT * FROM slots WHERE id = $1 FOR UPDATE;
-- Check if status = 'available'
-- If yes: INSERT booking + UPDATE slot status = 'booked'
COMMIT;
```

If two users hit `POST /bookings` at the same instant, one gets `200 OK` and the other gets `409 Conflict` with a clear message.

---

## What I Cut & Why

| Cut | Reason |
|-----|--------|
| Full JWT auth | Hardcoded users + header is enough to demo the core flow; auth is not the interesting problem here |
| Real-time websocket updates | Polling approach is simpler and reliable within 6 hours |
| Payment flow | Out of scope for a slot-booking MVP |

---

## What I'd Do With One More Day

- Add JWT-based auth properly
- WebSocket for live slot status updates across devices
- Push notifications for booking confirmation
- Dockerize the backend
- Write unit tests for the booking transaction logic

---

## AI Usage Note

Used **Claude** for:
- Boilerplate Express route structure
- `.env` URL-encoding issue debug (`@` and `#` in password breaking PostgreSQL connection string)
- GetX folder structure scaffolding commands

**One thing it got wrong:** Claude initially suggested a direct Supabase connection string which failed due to IPv4 incompatibility on local network — had to manually switch to the Session Pooler URL from Supabase dashboard to fix the connection.

---

## Seed Data

5 venues seeded:
- Green Turf Arena — Football, Andheri West
- Smash Badminton Club — Badminton, Powai
- City Sports Complex — Badminton, Bandra
- Pro Turf Ground — Football, Malad
- Elite Badminton Academy — Badminton, Goregaon

Slots: hourly from **6 AM to 10 PM** for each venue.