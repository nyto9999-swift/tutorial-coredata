## Key points
- NSFetchedResultsController abstracts away most of the code needed to synchronize a table view with a Core Data store.
- At its core, NSFetchedResultsController is a wrapper around an NSFetchRequest and a container for its fetched results.
- A fetched results controller requires setting at least one sort descriptor on its fetch request. If you forget the sort descriptor, your app will crash.
- You can set a fetched result’s controller sectionNameKeyPath to specify an attribute to group the results into table view sections. Each unique value corresponds to a different table view section.
- Grouping a set of fetched results into sections is an expensive operation. Avoid having to compute sections multiple times by specifying a cache name on your fetched results controller.
- A fetched results controller can listen for changes in its result set and notify its delegate, NSFetchedResultsControllerDelegate, to respond to these changes.
- NSFetchedResultsControllerDelegate monitors changes in individual Core Data records (whether they were inserted, deleted or modified) as well as changes to entire sections.
- Diffable data sources make working with fetched results controllers and table views easier.

## Key words
```
UITableViewDiffableDataSource, frc, NSManagedObjectID
```
