### Structure for Flutter App Architecture:

This Codebase use UI-Domain-Data Architecture.

Some Important Tid bits about packages used in this codebase:

1. Freezed & Riverpod Combination:
   - Use Riverpod to wrap Freezed state to make it reactive
   - Expose Freezed state in Riverpod hooks
   - Example: in [product_category_list_provider.dart](lib/main/presentation/product_category/category_list/riverpod/product_category_list_provider.dart)

2. Isar Community Edition:
   - Use [Isar Community Edition](https://pub.dev/packages/isar_community) instead of [Isar](https://isar.dev/) for local database storage & caching
   - Example: in [storage.dart](lib/main/core/storage.dart)

3. Dio:
   - Use [Dio](https://pub.dev/packages/dio) for network call
   - Example: in [http.dart](lib/main/core/http.dart)

4. Flutter_hooks:
   - Use [flutter_hooks](https://pub.dev/packages/flutter_hooks) for reactive state management
   - Example: in [product_category_list_provider.dart](lib/main/presentation/product_category/category_list/riverpod/product_category_list_provider.dart)

5. Go Router:
   - Use [go_router](https://pub.dev/packages/go_router) for navigation
   - Example: in [router.dart](lib/main/ui/router.dart)

## Architecture Pattern:

- This project uses Architecture Pattern based on [Flutter Team's Best Practice](https://docs.flutter.dev/data-and-backend/state-mgmt/solutions)
- Reference: [Compass App Example](https://github.com/flutter/samples/tree/main/compass_app)

## Folder Structure

- Inside lib, the code is divided into 2 main parts:
  - [main](lib/main.dart): Main entrypoint of the app
  - [main/](lib/main/): Main application code
  - [deferred/](lib/deferred/): Deferred packages used in the app

- Both main and deferred use the same structure which is:
  - [core/](lib/main/core/): Core packages used in the app
  - [ui/](lib/main/ui/): UI layer
  - [domain/](lib/main/domain/): Domain layer
  - [data/](lib/main/data/): Data layer

- Each layer has its own architecture pattern:
  - [core/](lib/main/core/): This layer is the foundation of the app, it contains the code that is used by all layers
  - [ui/](lib/main/ui/): This layer is the presentation layer, it contains the code that is used to display the UI
  - [domain/](lib/main/domain/): This layer is the domain layer, it contains the code that is used to represent the business logic
  - [data/](lib/main/data/): This layer is the data layer, it contains the code that is used to represent the data

- What each layer contains:
  - [core/](lib/main/core/): This layer contains the code that is used by all layers
  - [ui/](lib/main/ui/): This layer contains UI grouped by feature
  - [domain/](lib/main/domain/): This layer contains "entities/", "repositories/" (contracts), "sealed_classes/", and "usecases/" files
  - [data/](lib/main/data/): This layer contains the "repositories/" (repositories implementation), "models/" (dto or isar registries), and "sources/" (data sources) files

## Data Flow Rule

- UI <-> Provider -> Domain (Sealed Classes, UseCases, Repositories) -> Data (Repository Implementation, Models, Data Sources)
- Data must go through provider before reaching UI
- UI Navigation is done by go router package
- Data is ALWAYS send in json format of Map<String, dynamic> with the actual data inside the key "data". Other keys such as "success", "message", "code" etc. are reserved for status and error purposes, and most of the time not needed. Take note when developing from fetching data then turning into Dto object

## Important Notes for Deferred

- Packages in deferred is allowed to use packages from main, but should not if it needs a separate instance (Ex. deferred package have their own instance for isar, but does not require a separate instance for dio or zstandard)
- For now, packages that is identified to need a separate instance is isar (which means each deferred package will have their own isar instance with their own set of registries or schemas)
- Some packages in deferred is not following the normal folder structure due to import from other developer environment, and require refactoring, but should follow the normal architecture pattern
- DTOs is made in advance to let agentic AI know what data structure looks like before implementing the logic. Therefore AI should NOT make or modify DTOs. If a UI require a new data structure, it should be reported to the developer to see if changes are necessary, and will be implemented manually only by the developer.
- Main package isar instance is implemented by overriding during initial app setup, but deferred package instance will be initialized lazily on first access and can be kept alive by using [Riverpod(keepAlive: true)](https://pub.dev/documentation/riverpod/latest/riverpod/Riverpod-constant.html). You should NOT do overriding in deferred for isar instance since it is not possible without loading the deferred package library.
