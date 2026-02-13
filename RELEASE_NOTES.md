# Release Notes – BookExplorer v1.0.0

## Release Date

Final Submission Version

---

## Version 1.0.0 – Initial Production Release

### Added

- Feed with remote API integration
- Pagination support
- Debounced search (500ms)
- Book details screen
- CoreData offline caching
- 24-hour TTL cache policy
- Firebase Authentication
- Firebase Realtime Database integration
- Favorites feature
- Notes/comments feature
- Retry logic for failed requests
- Structured error handling
- LoadState-based UI state management
- Dependency Injection container
- Async/Await concurrency support

---

### Improved

- HTTP 422 handling
- Query sanitization
- Description decoding resilience
- Duplicate prevention in cache
- Background CoreData writes
- Error propagation clarity

---

### Fixed

- Invalid OpenLibrary stopword query ("the")
- JSON decoding mismatches
- Task cancellation crashes
- CoreData transformer renaming issue
- Swift closure capture warnings
- Git test target conflicts

---

### Security

- Firebase secrets excluded from repository
- No credentials stored in code
- Proper request validation
- User-based database isolation

---

### Stability

- Graceful offline mode
- Fallback to cached data
- Safe optional handling
- Controlled error recovery

---

## Final Status

This release represents a stable, production-ready academic submission fulfilling all technical and architectural requirements.
