# core/

Foundation layer shared across all layers in this deferred module.

## Contains
- `storage.dart` — Module's own Isar instance (`@Riverpod(keepAlive: true)`) and directory provider.
- `providers/` — All Riverpod provider wiring (datasource → repo → usecase → exposed data).

## Rules
- Isar instance must use a **unique** `name` parameter per module (e.g., `'transjatim'`).
- Shared packages (Dio, Zstandard) are imported from `main/core/`, not recreated here.
