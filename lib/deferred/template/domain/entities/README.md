# domain/entities/

Immutable data objects representing the module's business concepts.

## Rules
- One subdirectory per feature/concept (e.g., `terminal/`, `route/`, `schedule/`).
- Use `@freezed` annotation — generates `*.freezed.dart`.
- All fields are **nullable** (`Type?`) unless guaranteed by the API.
- No JSON serialization — that belongs in DTOs (`data/models/dto/`).
