# data/

Data layer. Contains repository implementations, data models (DTO + Isar), and data sources (local + remote).

## Rules
- Repository implementation goes in `repositories/` — implements the contract from `domain/repositories/`.
- DTO→Isar conversion extensions live in the repository implementation file.
- Isar Registry→Entity conversion lives inside each registry class (`toEntity()` method).
- **⚠ DTOs are developer-created only** — AI agents must not generate or modify DTO files.
