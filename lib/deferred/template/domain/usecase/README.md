# domain/usecase/

One class per business action. Each wraps a single repository method.

## Rules
- Class name pattern: `{Action}{Feature}UseCase` (e.g., `GetRoutesUseCase`, `SyncTerminalsUseCase`, `SearchSchedulesUseCase`).
- Constructor takes the repository contract (not the implementation).
- Single `execute()` method — parameters match the repository method signature.
- No business logic beyond delegation; complex logic stays in the repository implementation.
