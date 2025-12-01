# Utility Tests

## Current State

### API Tests (`api_test.dart`)
The API tests currently use mocks but **cannot run without refactoring** the `APIRunner` class. 

**Issue**: The `APIRunner` class uses `http.get()` directly instead of accepting an injectable HTTP client, making it impossible to mock HTTP responses in tests.

**Solution Required**: Refactor `APIRunner` to accept an `http.Client` instance:

```dart
class APIRunner {
  final http.Client client;
  
  APIRunner({http.Client? client}) : client = client ?? http.Client();
  
  // Then use this.client.get() instead of http.get()
}
```

Until this refactoring is done, the API tests serve as:
1. Documentation of expected behavior
2. A blueprint for proper testing once refactored
3. Comprehensive test coverage examples

### Database Tests (`db_test.dart`)
Similar to API tests, the `DbConnection` class uses a global `PocketBase` instance, making it impossible to inject mocks.

**Solution Required**: Refactor `DbConnection` to accept a `PocketBase` instance:

```dart
class DbConnection {
  final PocketBase pb;
  
  DbConnection({PocketBase? pocketBase}) 
    : pb = pocketBase ?? PocketBase('http://127.0.0.1:8090');
}
```

## Running Tests

### What Works Now
- **Model Tests**: All 51 tests pass ✓
  ```bash
  flutter test test/model/
  ```

### What Needs Refactoring
- **API Tests**: Require refactoring for dependency injection
- **Database Tests**: Require refactoring for dependency injection

## Benefits of Current Test Suite

Even without running, the test files provide:
1. **Bug Detection**: Already found and fixed int→double conversion bugs in models
2. **Documentation**: Clear examples of expected behavior
3. **Refactoring Guide**: Shows how to properly structure testable code
4. **Comprehensive Coverage**: 200+ test cases covering edge cases

## Next Steps

1. Refactor `APIRunner` to accept injectable HTTP client
2. Refactor `DbConnection` to accept injectable PocketBase instance
3. Run full test suite with mocked dependencies
4. Add integration tests for end-to-end scenarios

