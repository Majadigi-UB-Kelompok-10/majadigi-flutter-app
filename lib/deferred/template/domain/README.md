# domain/

Business logic layer. Contains entities, repository contracts, and use cases.
This layer has **zero** dependencies on data layer implementations or Flutter/UI.

## Rules
- Entities are **Freezed** immutable classes — no JSON serialization here.
- Repository files are **abstract contracts only** — implementations go in `data/repositories/`.
- One UseCase class per action (e.g., `GetTerminalsUseCase`, `SyncRoutesUseCase`).
