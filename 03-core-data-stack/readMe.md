## Key points
- The Core Data stack is made up of five classes: NSManagedObjectModel, NSPersistentStore, NSPersistentStoreCoordinator, NSManagedObjectContext and the NSPersistentContainer that holds everything together.
- The managed object model represents each object type in your app’s data model, the properties they can have, and the relationship between them.
- A persistent store can be backed by a SQLite database (the default), XML, a binary file or in-memory store. You can also provide your own backing store with the incremental store API.
- The persistent store coordinator hides the implementation details of how your persistent stores are configured and presents a simple interface for your managed object context.
- The managed object context manages the lifecycles of the managed objects it creates or fetches. They are responsible for fetching, editing and deleting managed objects, as well as more powerful features such as validation, faulting and inverse relationship handling.

## key words
```
relationships, core data's components, core data stack, NSMutableOrderedSet
```

## important
```
  ///For NSMutableOrderedSet ordering the relationships, and avoid duplicate in context. 
  if let dog = currentDog,
    let walks = dog.walks?.mutableCopy()
      as? NSMutableOrderedSet {
      walks.add(walk)
      dog.walks = walks
  }
```
