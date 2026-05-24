# data/repositories/

Repository implementation. Implements the abstract contract from `domain/repositories/`.

## Rules
- One file per module (e.g., `{prefix}_repository_impl.dart`).
- Contains **DTO→Isar conversion extensions** at the top of the file.
- Implements the **SWR pattern**: `get*()` returns cached data immediately, then fire-and-forgets `sync*()`.
- `sync*()` fetches remote, converts DTO→Isar, and writes to local cache.
- Complex data joins (combining data from multiple sources) happen here.
