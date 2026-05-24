# core/providers/

Single file wiring all Riverpod providers for the module.

## Contains
- `{prefix}_providers.dart` — Datasource, repository, usecase, and exposed data providers.

## Rules
- **Private** providers (prefixed `_`) for: datasources, repository, and usecases.
- **Public** providers for: final data consumed by presentation layer.
- Sync usecases may be public if triggered from outside (e.g., initial data load).
- Every provider must `part '{prefix}_providers.g.dart'` for code generation.
