## Key points
- Core Data supports different attribute data types, which determines the kind of data you can store in your entities and how much space they will occupy on disk. Some common attribute data types are String, Date, and Double.
- The Binary Data attribute data type gives you the option of storing arbitrary amounts of binary data in your data model.
- The Transformable attribute data type lets you store any object that conforms to NSSecureCoding in your data model.
- Using an NSManagedObject subclass is a better way to work with a Core Data entity. You can either generate the subclass manually or let Xcode do it automatically.
- You can refine the set entities fetched by NSFetchRequest using an NSPredicate.
- You can set validation rules (e.g. maximum value and minimum value) to most attribute data types directly in the data model editor. The managed object context will throw an error if you try to save invalid data.

```
subclsses, tranformer, data validate, update coredata
```
