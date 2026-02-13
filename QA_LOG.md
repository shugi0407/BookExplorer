# Quality Assurance Log – BookExplorer

## 1. Testing Approach

We performed:

- Manual UI testing
- Unit testing
- Integration testing
- Offline scenario testing
- Error simulation

Testing was conducted on:

- iPhone Simulator
- iOS latest SDK

---

## 2. Functional Test Cases

### Feed

| Test Case | Expected Result | Status |
| --- | --- | --- |
| Load feed page 1 | Books displayed |  Passed |
| Scroll to bottom | Next page loads |  Passed |
| No internet | Cached feed shown |  Passed |
| Invalid query | Error state displayed |  Passed |

---

### Search

| Test Case | Expected Result | Status |
| --- | --- | --- |
| Type < 2 chars | Validation message |  Passed |
| Type valid query | Results displayed |  Passed |
| Rapid typing | Previous request cancelled |  Passed |
| Scroll pagination | More results load |  Passed |

---

### Book Details

| Test Case | Expected Result | Status |
| --- | --- | --- |
| Open details | Data displayed |  Passed |
| Offline details | Cached data shown |  Passed |
| Missing description | Graceful fallback |  Passed |

---

### Authentication

| Test Case | Expected Result | Status |
| --- | --- | --- |
| Register | Account created |  Passed |
| Login | Session started |  Passed |
| Logout | Session cleared |  Passed |
| Invalid password | Error shown |  Passed |

---

### Firebase Data

| Test Case | Expected Result | Status |
| --- | --- | --- |
| Add note | Stored in database |  Passed |
| Add favorite | Stored under user |  Passed |
| Data isolation | Only user data visible |  Passed |

---

## 3. Edge Case Testing

- Network timeout simulation
- HTTP 422 response handling
- JSON decoding type mismatch
- Task cancellation during search
- CoreData merge conflicts
- Optional unwrapping errors

All handled successfully.

---

## 4. Performance Testing

We verified:

- No UI blocking
- Smooth scrolling
- Background CoreData saving
- Efficient pagination
- Controlled network retries

Memory usage remained stable.

---

## 5. Known Non-Critical Warnings

- Haptic system simulator warning
- Firebase AppDelegate swizzling warning

These do not affect functionality.

---

## 6. Conclusion

All core features were tested and validated.

The application meets stability and usability standards for academic submission.
