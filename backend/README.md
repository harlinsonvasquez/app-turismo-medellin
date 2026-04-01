# Turismo Backend

Production-oriented Spring Boot backend for the AppTurismo platform. This backend is intentionally separated from the existing Flutter mobile app and is designed as a modular monolith that can evolve into three product surfaces:

- Tourist mobile app
- Admin/internal management
- Business onboarding web panel

## Stack

- Java 17
- Spring Boot 3
- Spring Web
- Spring Data JPA
- Spring Security
- PostgreSQL
- Flyway
- JWT authentication
- Maven

## Project Structure

```text
backend/
  src/main/java/com/turismo/
    config/
    security/
    common/
    exception/
    module/
      auth/
      user/
      business/
      place/
      event/
      itinerary/
      favorite/
      membership/
      safety/
  src/main/resources/
    application.yml
    application-local.yml
    db/migration/
```

## Local Database

Default local values:

- DB host: `localhost`
- DB port: `5432`
- DB name: `turismo_db`
- DB user: `postgres`
- DB password: `postgres`

Environment variables are supported through `application.yml`. See [`backend/.env.example`](./.env.example).

## Run PostgreSQL with Docker

From [`backend/`](./):

```bash
docker compose up -d
```

This starts PostgreSQL 16 with the expected local credentials.

## Run the Application

Because this environment did not include a standalone Maven installation, `mvnw.cmd` and `mvnw` are provided as lightweight launcher scripts that use `MAVEN_HOME` or a local Maven installation if available.

Windows:

```powershell
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=local
```

Linux/macOS:

```bash
chmod +x mvnw
./mvnw spring-boot:run -Dspring-boot.run.profiles=local
```

If you already have Maven installed globally:

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

The `local` profile also enables development-only permissive CORS for Flutter local origins such as `http://localhost:*` and `http://127.0.0.1:*`. Those rules are defined only in [`src/main/resources/application-local.yml`](./src/main/resources/application-local.yml) and are not applied unless you run with the `local` or `dev` profile.

## Flyway Migrations

Flyway runs automatically at startup. Migrations included:

- `V1__create_schema.sql`: all core tables, indexes, and foreign keys
- `V2__seed_initial_data.sql`: membership plans, sample users, businesses, places, events, safety tips, and favorites

## Seeded Accounts

These are meant for local development only:

- Admin: `admin@turismo.local`
- Business owner: `owner@provenza.local`
- Tourist: `alejandra@example.com`
- Password for seeded users: `ChangeMe123!`

Note: if the BCrypt hash is later rotated, update the migration or seed strategy accordingly.

## Public vs Protected Endpoints

Public endpoints:

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/places`
- `GET /api/places/{id}`
- `GET /api/events`
- `GET /api/events/{id}`
- `GET /api/safety-tips`
- `GET /api/safety-tips/{id}`
- `GET /api/membership-plans`
- `GET /api/businesses`
- `GET /api/businesses/{id}`
- `POST /api/itineraries/generate`

Protected endpoints:

- `GET /api/auth/me`
- `GET /api/businesses/me`
- `POST /api/businesses`
- `PUT /api/businesses/{id}`
- `POST/PUT/DELETE /api/places...`
- `POST/PUT/DELETE /api/events...`
- `GET/POST/DELETE /api/favorites...`
- `POST /api/itineraries`
- `GET /api/itineraries`
- `GET /api/itineraries/{id}`
- admin-only writes for membership plans and safety tips

## Example API Flow

Register tourist:

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Laura Gomez",
    "email": "laura@example.com",
    "password": "SecurePass123!"
  }'
```

Login:

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "laura@example.com",
    "password": "SecurePass123!"
  }'
```

Generate itinerary suggestion:

```bash
curl -X POST http://localhost:8080/api/itineraries/generate \
  -H "Content-Type: application/json" \
  -d '{
    "city": "Medellin",
    "totalDays": 3,
    "totalBudget": 600000,
    "travelStyle": "CULTURAL",
    "companionType": "COUPLE",
    "interests": ["Art", "Gastronomy", "Nature"],
    "safeZoneOnly": true
  }'
```

List places near a location:

```bash
curl "http://localhost:8080/api/places?city=Medellin&latitude=6.2094&longitude=-75.5712&radiusKm=8"
```

## Flutter Integration Direction

The existing Flutter app currently uses mock data under `lib/data/mock`. This backend aligns with the same product concepts:

- places and place detail screens map to `/api/places`
- event discovery maps to `/api/events`
- safety screen maps to `/api/safety-tips`
- saved/favorites screen maps to `/api/favorites`
- planner and generated itinerary screens map to `/api/itineraries/generate` and `/api/itineraries`
- business promotion flow maps to `/api/businesses` and `/api/membership-plans`

The next frontend integration step is to replace the mock repositories in Flutter with API clients and token storage.

## Notes

- The itinerary generation is deterministic and rule-based, not AI-driven.
- Writes for places and events are role-ready for `BUSINESS_OWNER` and `ADMIN`.
- Creating a business upgrades a tourist account into `BUSINESS_OWNER` for future onboarding flows.
