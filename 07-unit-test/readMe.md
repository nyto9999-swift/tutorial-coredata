## Key points
- Unit tests should follow the FIRST principles: Fast, Isolated, Repeatable, Self-verifying, and Timely.
- Create a persistent store specific for unit testing and reset its contents with every test. Using an in-memory SQLite store is the simplest approach.
- Core Data can be used asynchronously and is easily tested with the XCTestExpectation class.
