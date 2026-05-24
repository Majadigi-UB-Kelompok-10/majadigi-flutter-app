# presentation/widgets/

Reusable UI building blocks extracted from screens.

## Rules
- Typically `StatelessWidget` or `HookWidget` (if local state needed).
- Accept data via constructor parameters — no direct provider access.
- Use callbacks (`VoidCallback`, `ValueChanged<T>`) for user interaction.
- One widget per file. File name: `{prefix}_{widget_name}.dart`.
