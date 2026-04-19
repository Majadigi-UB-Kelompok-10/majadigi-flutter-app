## Project Structure

Project is defined using [Flutter recommended structure](https://docs.flutter.dev/app-architecture/case-study)

Notably the example used is the [Compass App by Flutter Team](https://github.com/flutter/samples/tree/main/compass_app)

### App Architecture:
1. UI Layer Object is organized by Feature
2. Data Layer is organized by Type
3. Domain is organized by Type

### Layer Distinction:
1. UI Layer contains View and ViewModel
2. Domain Layer bridge between ViewModel from UI Layer and Repository from Data Layer
3. Data Layer contains Repository, DataSource, and Services

For more information on how it is done in Flutter, refer to this [doc](https://docs.flutter.dev/app-architecture/case-study/dependency-injection)

### Technical Decisions

Some technical decisions were made to ensure maximum flexibility and ease of use, 
while maintaining a clean and maintainable codebase. For collaborative effort in
developing this app, some decisions were used to ensure consistent structure.
- Strictly follow App Architecture Best Practice based on Flutter Documentation
- Dismiss as much network call as possible from client
- App SDUI architecture uses Backend-For-Frontend (BFF), which mean NO data parsing into layout done in client to reduce overhead
- Always finish documentation for all part of codebase

### Changelog

While codebase is made as neatly as possible, there will always be
some part that will go unnoticed and might result in unreproducible
build. Therefore, this will act as a list of whats and whys a decision
is made in this codebase:

| Decision                                                                                                                                     | Why                                                  |
|----------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------|
| Added `<uses-permission android:name="android.permission.INTERNET"/>` inside [AndroidManifest.xml](android/app/src/main/AndroidManifest.xml) | Needed for Android App to have Internet Connection   |
| Change [app initialization](lib/main.dart) to async with Future<void> main async {} and added WidgetsFlutterBinding.ensureInitialized();     | Stac, Riverpod, and Dio initialization require async |

### Libraries
- [Riverpod](riverpod.dev)
  - For Global State Management
  - For Dependency Injection (DI) between Domain layer and Data layer
  - Require: Code Generation
- [Dio](https://pub.dev/packages/dio)
  - For Network Call 
- [Stac](stac.dev)
  - For Stac DSL (Domain-Specific Language) Conversion from Dart to JSON
  - Server Driven User Interface (SDUI) Layout Parsing
  - Require: Code Generation
- [Isar Community Edition](https://pub.dev/packages/isar_community)
  - For Local Database Storage & Caching
- [Font Awesome Flutter](https://pub.dev/packages/font_awesome_flutter)
  - For Awesome Icons
- [URL Launcher](https://pub.dev/packages/url_launcher)
  - Helper to open URL in device browser
- [Supabase Flutter](https://pub.dev/packages/supabase_flutter)
  - SDK to connect to Supabase
- Code Generator
  - json_serializable
  - json_annotation
  - build_runner
  - freezed