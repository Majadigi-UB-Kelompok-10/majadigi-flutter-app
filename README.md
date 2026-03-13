# majadigi_mobile

Majadigi Mobile App recreated (Filkom UB, University of Brawijaya, 2026)

# For Fresh Github Pull / Clone

### Requirement
- Flutter SDK Installed (Currently using Flutter v3.14.2)
- Git

- Run this command::
```
flutter pub get
```

## Project Structure

Project is defined using [Flutter recommended structure](https://docs.flutter.dev/app-architecture/case-study)

Notably the example used is the [Compass App by Flutter Team](https://github.com/flutter/samples/tree/main/compass_app)

### Architecture is divided into 3 layer, with different approach:
1. UI Layer Object is organized by Feature
2. Data Layer is organized by Type
3. Domain is organized by Type

### For clear distinction, here's what each layer in the project divided into (MVVM Model):
1. UI Layer contains View and ViewModel
2. Domain Layer bridge between ViewModel from UI Layer and Repository from Data Layer
3. Data Layer contains Repository, DataSource, and Services

Dependency Injection is done through Provider Class provided by [Riverpod](https://riverpod.dev/)

For more information on how it is done in Flutter, refer to this [doc](https://docs.flutter.dev/app-architecture/case-study/dependency-injection)
