## Backend Specific Architecture

This markdown serve as an overview on what the backend should do for this application to work. This should work as a context on why certain parts of this application needed certain kind of backend to work correctly.

This page will include all backend aspect needed for data fetching to work with compression and caching strategies to avoid multiple redundant network call, reducing as much data revalidation, and both frontend and backend load as much as possible to aim for the highest performance and lowest latency possible.

Backend implementation can be varying as long as it is able to provide the following feature.

### Caching

What is needed in the backend:

- Use Redis for response caching
- ETags to indicate IF any data in an endpoint changed (304 not modified)

### Compression

What is needed in the backend:

- Compress all response as zstandart/zstd (raw bytes)

The application will receive and decompress fast, then process the data.
