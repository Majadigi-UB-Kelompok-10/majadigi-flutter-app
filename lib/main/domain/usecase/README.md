### Why do we need this?

You might be wondering why we need a use cases layer when seemingly it does nothing except intercepting data layer then pass it to UI layer.

In clean architecture, UI layer should not know about the data layer and vice versa. It is also useful to use this layer to apply business logic like filtering and other fun stuff. Advanced data manipulation shouldn't happen in the data layer itself.