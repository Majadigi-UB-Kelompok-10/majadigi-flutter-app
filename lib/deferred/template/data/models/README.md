# data/models/

Data transfer objects (DTO) and Isar persistence schemas.

## Subdirectories
- `dto/{feature}/` — JSON ↔ Dart objects (Freezed + JsonSerializable). **⚠ Developer-created only.**
- `isar/{feature}/` — Isar `@collection` classes for local caching, each with a `toEntity()` method.
