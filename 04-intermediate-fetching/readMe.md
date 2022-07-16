## Key points
- NSFetchRequest is a generic type. It takes a type parameter that specifies the type of objects you expect to get as the result of the fetch request.
- If you expect to reuse the same type of fetch in different parts of your app, consider using the Data Model Editor to store an immutable fetch request directly in your data model.
- Use NSFetchRequest’s count result type to efficiently compute and return counts from SQLite.
- Use NSFetchRequest’s dictionary result type to efficiently compute and return averages, sums and other common calculations from SQLite.
- A fetch request uses different techniques such as using batch sizes, batch limits and faulting to limit the amount of information returned.
- Add a sort description to your fetch request to efficiently sort your fetched results.
- Fetching large amounts of information can block the main thread. Use NSAsynchronousFetchRequest to offload some of this work to a background thread.
- NSBatchUpdateRequest and NSBatchDeleteRequest reduce the amount of time and memory required to update or delete a large number of records in Core Data.
