# System Architecture – BookExplorer

## 1. Architectural Overview

BookExplorer was developed using a **layered MVVM architecture** combined with **Dependency Injection** to ensure modularity, scalability, and testability.

We separated the application into the following layers:

```
Presentation Layer
Domain Layer
Data Layer
Infrastructure Layer
```

This separation enforces:

- Clear responsibility boundaries
- Testable business logic
- Replaceable infrastructure components
- Clean dependency flow (top → down only)

---

## 2. Presentation Layer

### Technologies:

- SwiftUI
- Combine
- Async/Await
- @Published state management

### Components:

- Views (FeedView, SearchView, DetailView, ProfileView, LoginView)
- ViewModels (FeedViewModel, SearchViewModel, DetailViewModel, SessionViewModel)

### Responsibilities:

- UI rendering
- User interaction handling
- State transitions (LoadState)
- Calling domain repositories

Each ViewModel is marked with:

```swift
@MainActor
final class ViewModel: ObservableObject
```

We use:

```swift
@Published var state: LoadState<T>
```

to control UI transitions.

---

## 3. Domain Layer

### Core Models:

- `Book`
- `User`
- `Note`
- `Favorite`

### Repository Protocols:

- `BookRepositoryProtocol`
- `FavoriteRepositoryProtocol`
- `CommentRepositoryProtocol`

### Responsibilities:

- Business logic abstraction
- Repository contracts
- Merge policies
- Cache freshness validation

The domain layer does not depend on UI or Firebase directly.

---

## 4. Data Layer

### 4.1 Networking

We implemented a custom `APIClient` using:

- URLSession
- JSONDecoder
- Structured APIError
- Async/Await
- Request retry logic

We handle:

- HTTP status validation
- 422 query errors
- JSON decoding mismatches
- Cancellation errors
- Retry with delay

Endpoints:

- `/search.json`
- `/works/{workId}.json`

---

### 4.2 Local Persistence (CoreData)

We implemented:

- `CoreDataStack`
- `BookCacheEntity`
- Background context writes
- TTL cache policy (24h)
- Merge policy (duplicate prevention)

Caching strategy:

- Feed cached on fetch
- Details cached separately
- Cache preferred when fresh
- Offline fallback when network unavailable

---

### 4.3 Firebase Integration

We integrated:

### Firebase Authentication

- Email/password sign-up
- Login
- Logout
- Session state tracking

### Firebase Realtime Database

Data structure:

```
users/{userId}/favorites/
users/{userId}/notes/
```

Security:

- No secrets committed
- Firebase config excluded via .gitignore
- User-based isolation

---

## 5. Dependency Injection

We implemented a singleton DIContainer:

```swift
final class DIContainer
```

Injected services:

- APIClient
- CoreDataStack
- BookRepository
- Firebase repositories

This ensures:

- Testability
- Decoupled architecture
- Centralized dependency management

---

## 6. Concurrency Model

We used:

- Swift Concurrency (async/await)
- Task cancellation
- Debounced search (500ms delay)
- Background CoreData saving
- @MainActor for UI safety

Cancellation handling prevents redundant network calls.

---

## 7. Error Handling Strategy

We implemented structured error types:

```swift
enum APIError
```

States supported:

- loading
- loaded
- empty
- failed
- idle

All errors propagate through ViewModel → LoadState → UI.

---

## 8. Offline Strategy

When offline:

- Feed displays cached data
- Details display cached version
- Notes and favorites remain available
- App does not crash

Cache TTL ensures data freshness balance.

---

## 9. Scalability Considerations

The architecture supports:

- Replacing OpenLibrary with another API
- Migrating to Firestore
- Adding pagination improvements
- Adding push notifications
- Expanding to iPad

---

## 10. Conclusion

The architecture ensures:

- Separation of concerns
- Clean data flow
- Offline resilience
- Structured error management
- Production-ready scalability

The system meets academic and production architectural standards.
