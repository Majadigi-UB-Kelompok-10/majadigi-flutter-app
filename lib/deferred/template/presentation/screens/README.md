# presentation/screens/

Full-page screen widgets. Each screen is a route destination.

## Rules
- Use `HookConsumerWidget` (combines Flutter Hooks + Riverpod).
- Consume data via `ref.watch({prefix}{Feature}Provider)`.
- Handle loading/error states with `.when(data:, loading:, error:)`.
- Use `useState` for local UI state, `useEffect` for side effects.
- Navigate with `context.push('/path')` or `context.pop()`.
