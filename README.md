# QuickSlot 🏸⚽

A full-stack sports slot booking application built as part of a Flutter Developer Hackathon.

The application allows users to browse sports venues, view available time slots for a selected date, book slots, manage bookings, and prevents double-booking through a concurrency-safe backend implementation.

---

# Tech Stack

## Frontend

* Flutter
* GetX (State Management, Dependency Injection, Routing)
* Dio (REST API Client)

## Backend

* Node.js
* Express.js

## Database

* PostgreSQL (Supabase)

## Architecture

* Clean feature-based Flutter structure
* REST API communication
* Transaction-based booking system
* Repository/API Provider pattern

---

# Features Implemented

## Authentication (Lightweight)

To focus on the core booking problem rather than authentication complexity, the application uses predefined users and an `X-User-Id` header.

Users can:

* Select a user profile
* Continue into the application
* Access personal bookings

---

## Venue Management

Users can:

* View all available sports venues
* See sport type and location
* Navigate to venue details

Seeded venues:

1. Green Turf Arena
2. Smash Badminton Club
3. City Sports Complex
4. Pro Turf Ground
5. Elite Badminton Academy

---

## Slot Management

Users can:

* Select a date
* View available slots
* View booked slots
* Book available slots

Features:

* Date picker
* Responsive slot grid
* Available/Booked status indicators
* Loading states
* Empty states
* Error states with retry

Slots are generated hourly from:

06:00 AM → 10:00 PM

---

## Booking Flow

1. User selects a slot
2. Booking confirmation dialog appears
3. Request sent to backend
4. Booking created successfully
5. Slot list refreshes automatically

If another user books the slot first:

* Backend returns `409 Conflict`
* Flutter displays a user-friendly message
* Slot list refreshes automatically

---

## My Bookings

Users can:

* View all their bookings
* Cancel bookings
* See updated booking status instantly

Features:

* Loading state
* Empty state
* Error handling
* Confirmation dialog before cancellation

---

# Backend API

## GET /venues

Returns all available venues.

---

## GET /venues/:id/slots?date=YYYY-MM-DD

Returns slots for a selected venue and date.

---

## POST /bookings

Creates a booking.

Headers:

```http
X-User-Id: user1
```

Body:

```json
{
  "slot_id": 17
}
```

Possible Responses:

```http
200 OK
```

```http
409 Conflict
```

```http
400 Bad Request
```

---

## GET /users/:id/bookings

Returns bookings for a user.

---

## DELETE /bookings/:id

Cancels a booking.

---

# Database Design

## venues

| Column   | Type    |
| -------- | ------- |
| id       | integer |
| name     | text    |
| sport    | text    |
| location | text    |

## slots

| Column     | Type    |
| ---------- | ------- |
| id         | integer |
| venue_id   | integer |
| date       | date    |
| start_time | time    |
| end_time   | time    |
| status     | text    |

## bookings

| Column     | Type      |
| ---------- | --------- |
| id         | integer   |
| slot_id    | integer   |
| user_id    | text      |
| created_at | timestamp |

## users

| Column | Type |
| ------ | ---- |
| id     | text |
| name   | text |

---

# Concurrency-Safe Booking Strategy

The most critical requirement of this assignment is preventing double booking.

Implementation:

1. Booking request starts a PostgreSQL transaction.
2. Target slot row is locked using:

```sql
SELECT * FROM slots
WHERE id = $1
FOR UPDATE;
```

3. Backend checks current status.
4. If available:

    * Create booking
    * Update slot status to booked
    * Commit transaction
5. If already booked:

    * Rollback transaction
    * Return 409 Conflict

Result:

When two users attempt to book the same slot simultaneously:

* Exactly one succeeds.
* The second receives a conflict response.
* No duplicate bookings are created.

---

# Flutter Architecture

```text
lib/
│
├── app/
│   ├── routes/
│   └── bindings/
│
├── data/
│   ├── models/
│   └── providers/
│
├── modules/
│   ├── auth/
│   ├── venues/
│   ├── bookings/
│   └── venue_details/
│
├── widgets/
│
└── main.dart
```

### Why GetX?

Chosen because:

* Minimal boilerplate
* Fast development
* Reactive UI updates
* Built-in routing
* Dependency injection support

Ideal for hackathon development where delivery speed matters.

---

# Error Handling

Frontend handles:

* API failures
* Empty responses
* Network issues
* Booking conflicts
* Invalid operations

Backend handles:

* Validation failures
* Missing resources
* Booking conflicts
* Database transaction failures

---

# What Was Deliberately Cut

To ensure a reliable and complete solution within the time limit:

* JWT Authentication
* User Registration
* Payment Integration
* Push Notifications
* WebSocket Updates
* Admin Dashboard

These features are valuable but not essential to solving the core booking problem.

---

# What I Would Build Next

Given an additional day:

* JWT Authentication
* WebSocket-based live slot updates
* Offline caching
* Docker deployment
* Unit tests
* Widget tests
* Booking analytics dashboard
* CI/CD pipeline

---

# AI Usage Note

AI tools were used as productivity assistants for:

* API scaffolding
* Flutter UI boilerplate
* GetX project structure
* PostgreSQL connection troubleshooting
* Error debugging

All generated code was reviewed, modified, tested, and understood before integration.

### Example of AI Mistake Found and Corrected

An AI-generated PostgreSQL connection string initially failed because it used an incompatible connection endpoint. The issue was identified during testing and corrected by switching to the appropriate Supabase Session Pooler connection string.

This reinforced the importance of validating AI-generated suggestions before production use.

---

# Demo Checklist

✅ User Selection

✅ Venue Listing

✅ Venue Details

✅ Date Selection

✅ Slot Availability

✅ Booking Flow

✅ Conflict Handling

✅ My Bookings

✅ Cancel Booking

✅ PostgreSQL Persistence

✅ Concurrency-Safe Transactions

✅ Flutter + GetX Architecture

✅ Supabase Integration
