## Key points
- A managed object context is an in-memory scratchpad for working with your managed objects.
- Private background contexts can be used to prevent blocking the main UI.
- Contexts are associated with specific queues and should only be accessed on those queues.
- Child contexts can simplify an app’s architecture by making saving or throwing away edits easy.
- Managed objects are tightly bound to their context, and can’t be used with other contexts.
- Surfers talk funny.

## Key words
```
userdefault, csv, sqlite, filehandler(for writting), performBackgroundTask, childContext
```

## note
```
coalescedHeight = height != nil ? height! : "" can be shortened using the nil coalescing operator to: let coalescedHeight = height ?? "".
```
