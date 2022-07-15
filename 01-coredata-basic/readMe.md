## Key points
- Core Data provides on-disk persistence, which means your data will be accessible even after terminating your app or shutting down your device. This is different from in-memory persistence, which will only save your data as long as your app is in memory, either in the foreground or in the background.
- Xcode comes with a powerful Data Model editor, which you can use to create your managed object model.
- A managed object model is made up of entities, attributes and relationships
- An entity is a class definition in Core Data.
- An attribute is a piece of information attached to an entity.
- A relationship is a link between multiple entities.
- An NSManagedObject is a run-time representation of a Core Data entity. You can read and write to its attributes using Key-Value Coding.
- You need an NSManagedObjectContext to save() or fetch(_:) data to and from Core Data.
