## Key points
- Most implementations of Core Data are fast and light already, due to Core Data’s built-in optimizations, such as faulting.
- When making improvements to Core Data performance you should measure, make targeted changes and then measure again to validate your changes had the intended impact.
- Small changes to the data model, such as moving large binary blobs to other entities, can improve performance.
- For optimal performance, you should limit the amount of data you fetch to the minimum needed: the more data you fetch, the longer the fetch will take.
- Performance is a balance between memory and speed. When using Core Data in your apps, always keep this balance in mind.
