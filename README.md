# BookExplorer

**Final Native Mobile Development Project (iOS)**

Swift Track

## Authors

- Student 1: R.Shugyla
- Student 2: Zh.Aruana

---

# 1. Project Overview

BookExplorer is a native iOS application developed using **SwiftUI**, **MVVM architecture**, **CoreData**, and **Firebase**.

The goal of this project was to design and implement a production-ready mobile application that integrates:

- Remote API consumption
- Offline caching
- User authentication
- Real-time cloud database
- Pagination
- Debounced search
- Error handling & retry logic
- Clean architecture principles

The application allows users to:

- Browse books (Feed)
- Search books
- View detailed book information
- Create notes/comments
- Save favorites
- Authenticate via Firebase
- Access cached data offline

---

# 2. Architecture

We implemented the application using **MVVM (Model-View-ViewModel)** with Dependency Injection.

## 2.1 Architectural Layers

### Presentation Layer

- SwiftUI Views
- ViewModels
- State management via `@Published`
- Async/await data flow

### Domain Layer

- Book model
- Repository protocols
- Business logic
- Use case abstraction

### Data Layer

- APIClient (network layer)
- BookRepository
- CoreDataStack
- Firebase repositories

We used a centralized `DIContainer` to manage dependencies and ensure testability.

---

# 3. Implemented Features

## 3.1 Feed (Remote + Pagination)

We implemented:

- Remote book fetching via OpenLibrary API
- Pagination support
- Error handling for HTTP failures
- Automatic retry mechanism
- CoreData caching
- Offline fallback support

The Feed uses:

```
GET https://openlibrary.org/search.json
```

We handled:

- HTTP 422 errors (invalid queries)
- Network cancellation errors
- JSON decoding mismatches

---

## 3.2 Search (Debounced + Async)

We implemented:

- Debounced search (500ms delay)
- Task cancellation support
- Pagination on scroll
- Minimum query length validation
- Retry mechanism

The SearchViewModel:

- Cancels previous tasks
- Avoids duplicate requests
- Updates UI state reactively

---

## 3.3 Book Details

We implemented:

- Work details fetch via:

```
GET https://openlibrary.org/works/{workId}.json
```

- Merge policy for cached and remote data
- Support for inconsistent API description formats
- Offline cached details support

---

## 3.4 CoreData Offline Caching

We implemented:

- `BookCacheEntity`
- Cache TTL (24 hours)
- Background context saving
- Duplicate prevention
- Merge policy logic

The app:

- Prefers fresh cache
- Falls back to remote if expired
- Shows cached feed when offline

---

## 3.5 Firebase Integration

We integrated:

### Firebase Authentication

- Email/password login
- Sign up
- Sign out
- Session management

### Firebase Realtime Database

We implemented:

- User notes/comments storage
- Favorites storage
- User-based data separation

Security:

- `GoogleService-Info.plist` excluded from repository
- No secrets committed
- User-based database paths

---

# 4. State Management

We implemented a unified LoadState enum:

```
enum LoadState<T>
```

Supporting:

- idle
- loading
- loaded
- empty
- failed

This ensures:

- Clear UI state transitions
- Proper error presentation
- Retry capability

---

# 5. Networking Layer

We implemented:

- Custom `APIClient`
- Structured `APIError`
- HTTP status validation
- JSONDecoder handling
- Logging in debug mode
- Proper header configuration

We resolved:

- 422 validation errors
- Query sanitization issues
- API description decoding inconsistencies

---

# 6. Error Handling & Stability

We implemented:

- Retry mechanism with delay
- Task cancellation handling
- Graceful UI failure states
- Decoding fallback logic
- Safe optional unwrapping
- Defensive data mapping

---

# 7. Performance & Optimization

We implemented:

- Debounced search
- Pagination
- Background CoreData saving
- Lazy list rendering
- Cancellation of redundant network calls
- Reduced main-thread blocking

---

# 8. Dependencies

We used:

- SwiftUI
- Combine
- CoreData
- FirebaseAuth
- FirebaseDatabase
- URLSession
- Swift Concurrency (async/await)

No third-party UI libraries were used.

---

# 9. Security Considerations

We ensured:

- No secrets in repository
- Firebase config excluded via `.gitignore`
- No hardcoded credentials
- Proper network request validation
- Safe decoding logic

---

# 10. Testing

We implemented:

- Unit tests for core logic
- Debounce tests
- Validation tests
- Repository tests
- Merge policy tests

We ensured:

- Proper target configuration
- No module conflicts
- Clean test execution

---

# 11. Release Preparation

We prepared:

- Release configuration
- Clean build
- Versioning (1.0.0)
- Archive build
- Logging disabled for Release

---

# 12. Challenges & Resolutions

During development we resolved:

- HTTP 422 errors from OpenLibrary (blocked queries)
- JSON type mismatches in API
- Task cancellation behavior
- CoreData model mismatches
- Firebase module import conflicts
- Git target duplication issues
- Swift Concurrency closure capture warnings

Each issue was systematically debugged and corrected.

---

# 13. Conclusion

In this project, we successfully:

- Designed a scalable MVVM architecture
- Integrated remote APIs
- Implemented offline caching
- Integrated Firebase authentication & database
- Ensured stability and error handling
- Delivered a production-ready iOS application

The application meets all functional and technical requirements of the Final Native Mobile Development Project.

---
