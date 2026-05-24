# data/datasources/

Abstract contracts + implementations for local (Isar) and remote (Dio) data access.

## Files
- `{prefix}_local_datasource.dart` — Abstract contract + `{Prefix}LocalDatasourceImpl` using Isar.
- `{prefix}_remote_datasource.dart` — Abstract contract + `{Prefix}RemoteDatasourceImpl` using Dio + Zstandard.

## Rules
- Both abstract and implementation class live in the **same file** per datasource type.
- Local datasource operates on Isar registry objects (not entities or DTOs).
- Remote datasource returns DTOs (or `null` on failure).
- Remote datasource uses `cleanupData()` from `main/data/datasources/decompression.dart` for response handling.
