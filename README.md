# app_turismo

Flutter mobile client for AppTurismo.

## Local backend integration

The app now consumes the Spring Boot backend under `backend/` instead of local mock data.

Default API base URL rules:

- Web: `http://localhost:8080`
- Android emulator: `http://10.0.2.2:8080`
- iOS simulator / desktop: `http://localhost:8080`

You can override it with a dart define:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8080
```

Example for a physical device on the same network:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.20:8080
```

Run the backend with the `local` Spring profile so the development-only CORS rules are enabled:

```bash
cd backend
docker compose up -d
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=local
```

## What is now connected

- Authentication: `/api/auth/login`, `/api/auth/register`, `/api/auth/me`
- Places: `/api/places`
- Events: `/api/events`
- Safety tips: `/api/safety-tips`
- Membership plans: `/api/membership-plans`
- Favorites: `/api/favorites`
- Itineraries: `/api/itineraries/generate`, `/api/itineraries`

## Notes

- The old mock files remain in the repository only as historical reference, but the app no longer uses them as the source of truth.
- JWT is stored locally and attached automatically to authenticated requests.
- Saved items and itinerary persistence require login.
