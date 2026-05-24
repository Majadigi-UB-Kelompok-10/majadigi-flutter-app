# presentation/

UI layer. Contains screens (full pages) and reusable widgets.

## Terminology
`presentation/` and `ui/` are synonyms in this codebase. **Prefer `presentation/`** for all new modules.

## Rules
- Screens use `HookConsumerWidget` to combine Flutter Hooks + Riverpod.
- Data flows through Riverpod providers only — never call repositories or datasources directly.
- Navigation uses `go_router` (`context.push()`, `context.pop()`).
- Widgets are reusable, stateless building blocks extracted from screens.
