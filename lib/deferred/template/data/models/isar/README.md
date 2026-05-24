# data/models/isar/

Isar `@collection` classes for local database persistence. One subdirectory per feature.

## Rules
- Class name: `Isar{Prefix}{Feature}Registry`.
- Must include a `toEntity()` method annotated with `@ignore` to convert to domain entity.
- `Id get isarId => id;` pattern for Isar primary key.
- Use `@Index` on fields that are queried/filtered frequently.
- Schemas must be registered in `core/storage.dart`.
