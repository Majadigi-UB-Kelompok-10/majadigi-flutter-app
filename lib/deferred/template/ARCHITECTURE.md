# Deferred Module Architecture Reference

> This file is the single source of truth for AI agents scaffolding a new deferred module.
> When this directory (`lib/deferred/template/`) is provided as context, this file plus the
> skeleton `.dart` files give you everything needed to implement a module correctly.

---

## Architecture: UI-Domain-Data

```
Presentation ←→ Provider → Domain (Entities, UseCases, Repository contracts) → Data (Repository impl, Models, DataSources)
```

### Terminology
- **`presentation/`** and **`ui/`** are synonyms in this codebase. **Prefer `presentation/`** for all new deferred modules.

---

## Directory Layout (per deferred module)

```
lib/deferred/{module_name}/
├── core/
│   ├── storage.dart              # Own Isar instance (keepAlive), directory provider
│   └── providers/
│       └── {prefix}_providers.dart   # All Riverpod providers: datasources → repo → usecases → exposed data
│
├── domain/
│   ├── entities/{feature}/
│   │   └── {prefix}_{feature}_entity.dart        # Freezed immutable entity
│   ├── repositories/
│   │   └── {prefix}_repository.dart              # Abstract contract (what the module CAN do)
│   └── usecase/
│       └── {prefix}_use_cases.dart               # One class per action (Get*, Sync*, Search*)
│
├── data/
│   ├── models/
│   │   ├── dto/{feature}/
│   │   │   └── {feature}_dto.dart                # ⚠ DO NOT generate — created by developer only
│   │   └── isar/{feature}/
│   │       └── {prefix}_{feature}_registry.dart  # @collection with toEntity()
│   ├── datasources/
│   │   ├── {prefix}_local_datasource.dart        # Abstract + Impl (Isar CRUD)
│   │   └── {prefix}_remote_datasource.dart       # Abstract + Impl (Dio + Zstandard)
│   └── repositories/
│       └── {prefix}_repository_impl.dart         # Implements domain contract, DTO→Isar extensions
│
└── presentation/
    ├── screens/
    │   └── {prefix}_screen.dart                  # HookConsumerWidget (full page)
    └── widgets/
        └── {prefix}_{widget_name}.dart           # Reusable StatelessWidget / HookWidget
```

---

## Key Packages & Usage

| Package | Purpose | Notes |
|---|---|---|
| `riverpod_annotation` | DI + state management | Use `@riverpod` / `@Riverpod(keepAlive: true)` with code-gen |
| `freezed_annotation` | Immutable entities & DTOs | Entities: `part '*.freezed.dart'`; DTOs: also `part '*.g.dart'` |
| `isar_community` | Local cache database | Each deferred module has its **own** Isar instance |
| `dio` | HTTP client | **Shared** from `main/core/http.dart` — do NOT create a new instance |
| `zstandard` | Response decompression | **Shared** from `main/core/http.dart` |
| `flutter_hooks` | Reactive UI state | `useState`, `useEffect`, `useMemoized` in `HookConsumerWidget` |
| `go_router` | Navigation | Routes defined in `main/core/router.dart` |
| `cached_network_image` | Image caching | Use shared `getCustomCacheManagerProvider` from `main/core/storage.dart` |

---

## Data Flow Rules

1. **API response format**: JSON is always `{ "data": [...], "success": bool, "message": str }`. The actual payload is inside `"data"`. Other keys are metadata — usually ignored.
2. **Deserialization pipeline**: Raw JSON → `cleanupData()` (handles Zstandard decompression) → `Dto.fromJson()` → Isar Registry (for caching) or Entity (for direct use).
3. **SWR (Stale-While-Revalidate) pattern**: Repository `get*()` methods return cached data immediately, then fire-and-forget a `sync*()` call to refresh the cache in the background.
4. **Data never reaches UI directly** — it must flow through Riverpod providers.
5. **Provider wiring order** (all in `core/providers/`):
   ```
   Isar instance (keepAlive) → LocalDatasource → RemoteDatasource → Repository → UseCase → Exposed data provider
   ```
   Private providers (prefixed `_`) for datasources, repo, and usecases. Only the final data providers are public.

---

## Deferred-Specific Rules

| Rule | Detail |
|---|---|
| **Own Isar instance** | Each deferred module opens its own Isar DB with `name: '{module_name}'`. Use `@Riverpod(keepAlive: true)` so it persists for the app lifetime. |
| **Shared Dio & Zstandard** | Import from `package:majadigi_mobile_rebuild/main/core/http.dart`. Do NOT create separate instances. |
| **Can import from `main/`** | Deferred modules may use `main/` packages (Dio, Zstandard, cache manager, theme). |
| **Cannot import between deferred modules** | Deferred modules must NOT import from each other. |
| **Lazy initialization** | Isar is initialized on first access via the provider, not at app startup. No overriding like `main/` does. |
| **⚠ DTO immutability** | **AI agents must NOT create or modify DTO files.** DTOs are always created by the developer before any AI task begins. The skeleton `example_dto.dart` is reference-only. If a new data structure is needed, report it to the developer. |

---

## Naming Conventions

| Item | Pattern | Example (prefix = `Tj`) |
|---|---|---|
| Entity class | `{Prefix}{Feature}Entity` | `TjTerminalEntity` |
| Entity file | `{prefix}_{feature}_entity.dart` | `tj_terminal_entity.dart` |
| DTO class | `{Feature}Dto` | `TerminalDto` |
| DTO file | `{feature}_dto.dart` | `terminal_dto.dart` |
| Isar registry class | `Isar{Prefix}{Feature}Registry` | `IsarTjTerminalRegistry` |
| Isar registry file | `{prefix}_{feature}_registry.dart` | `tj_terminal_registry.dart` |
| Repository contract | `{Prefix}Repository` | `TjRepository` |
| Repository impl | `{Prefix}RepositoryImpl` | `TjRepositoryImpl` |
| UseCase class | `{Action}{Feature}UseCase` | `GetTerminalsUseCase`, `SyncRoutesUseCase` |
| Provider file | `{prefix}_providers.dart` | `tj_providers.dart` |
| Screen class | `{Prefix}Screen` | `TjScreen` |
| Widget class | `{Prefix}{WidgetName}` | `TjPriceCard` |

---

## Code Generation

After creating/modifying Freezed entities, DTOs, Isar registries, or Riverpod providers, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates the `*.freezed.dart`, `*.g.dart` files required by the annotations.

---

## Conversion Helpers

DTO → Isar Registry conversion is done via **extensions** in the repository implementation file (NOT in the DTO or registry files themselves). Example:

```dart
extension {Feature}DtoToIsar on {Feature}Dto {
  Isar{Prefix}{Feature}Registry toIsar() {
    return Isar{Prefix}{Feature}Registry()
      ..field1 = field1
      ..field2 = field2;
  }
}
```

Isar Registry → Entity conversion is done via a `toEntity()` method **inside** the registry class.
