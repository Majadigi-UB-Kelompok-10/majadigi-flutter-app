# domain/repositories/

Abstract repository contracts defining what operations the module supports.

## Rules
- One file per module (e.g., `{prefix}_repository.dart`).
- Contains **only** the abstract class — implementation is in `data/repositories/`.
- Methods return domain entities, never DTOs or Isar registries.
- Include both `get*()` (read) and `sync*()` (cache refresh) methods.
