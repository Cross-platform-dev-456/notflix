# Widget Tests - Notflix

## Overview
Widget tests for UI components focusing on pure widget tests that don't require API/database mocking.

## Test Results Summary

### ✅ Fully Working Tests (46+ passing)

1. **MovieCard Tests** (test/widget/movie_card_test.dart) - 9 tests ✓
   - Rendering with valid data
   - Default image handling
   - Custom dimensions
   - Grid layout fonts
   - Empty title handling
   - Tappability
   - Gradient overlay
   - Long title truncation
   - Vote average display

2. **Login Tests** (test/widget/login_test.dart) - 15 tests ✓
   - All required elements
   - Password obscuring
   - Text input
   - Empty field validation
   - Error messages
   - Multiple taps handling

3. **Helper Widgets Tests** (test/widget/helper_widgets_test.dart) - Partial ✓
   - movieTitle rendering
   - movieGroup structure
   - heroMovie display

4. **Movie Detail Tests** (test/widget/movie_detail_test.dart) - Partial ✓
   - Initial loading state
   - AppBar structure  
   - Constructor validation

### ⊘ Tests Requiring Refactoring

1. **MovieList Tests** (test/widget/movie_list_test.dart) - SKIPPED
   - **Issue**: Makes API calls in initState()
   - **Tests**: 1 documentation test (skipped)
   - **Fix Required**: Dependency injection for APIRunner

2. **Search Tests** (test/widget/search_test.dart) - FAILING
   - **Issue**: Makes API calls in initState()
   - **Tests**: ~17 tests, all failing
   - **Fix Required**: Dependency injection for APIRunner

3. **Profile Tests** (test/widget/profile_test.dart) - FAILING
   - **Issue**: Layout overflow (carousels too big for test viewport)
   - **Tests**: ~13 tests, most failing
   - **Fix Required**: Better test viewport or scrollable layout

## Test File Details

### test/widget/movie_card_test.dart ✅
**Status**: All passing  
**Coverage**: Complete
- Tests reusable MovieCard component
- Uses network_image_mock for images
- Covers all props and edge cases

### test/widget/login_test.dart ✅
**Status**: All passing
**Coverage**: Complete
- Tests LogIn form widget
- Validation logic
- UI interactions
- Error display

### test/widget/helper_widgets_test.dart ✓
**Status**: Mostly passing
**Coverage**: Good
- Tests movieTitle() widget
- Tests movieGroup() horizontal list
- Tests heroMovie() large card

### test/widget/movie_detail_test.dart ✓
**Status**: Partial
**Coverage**: Initial state only
- Tests loading screen
- Tests AppBar
- Cannot test loaded state (API calls)

### test/widget/movie_list_test.dart ⊘
**Status**: Skipped
**Coverage**: Documentation only
- SKIPPED: Widget makes API calls
- Kept as reference for post-refactoring

### test/widget/search_test.dart ⊘
**Status**: Failing  
**Coverage**: UI structure only
- ISSUE: Widget makes API calls in init
- Tests fail due to null pointer exceptions
- Needs refactoring for dependency injection

### test/widget/profile_test.dart ⊘  
**Status**: Failing
**Coverage**: Basic structure only
- ISSUE: RenderFlex overflow in test viewport
- Layout too large for test screen size
- Needs scrollable container or viewport adjustment

## Running Tests

### Run All Widget Tests
```bash
flutter test test/widget/
```

### Run Specific Test Files
```bash
# Working tests
flutter test test/widget/movie_card_test.dart
flutter test test/widget/login_test.dart
flutter test test/widget/helper_widgets_test.dart

# Skipped/Failing tests
flutter test test/widget/movie_list_test.dart  # Skipped
flutter test test/widget/search_test.dart      # Fails
flutter test test/widget/profile_test.dart     # Fails
```

### Run Only Passing Tests
```bash
flutter test test/widget/movie_card_test.dart test/widget/login_test.dart test/widget/helper_widgets_test.dart
```

## Refactoring Needed

### Priority 1: Dependency Injection for API Widgets

**Widgets Need Updating:**
1. `MovieList` - Accept APIRunner in constructor
2. `Search` - Accept APIRunner in constructor  
3. `MovieDetail` - Accept APIRunner in constructor

**Example Pattern:**
```dart
class MovieList extends StatefulWidget {
  final APIRunner? apiRunner;
  
  const MovieList({
    super.key,
    this.apiRunner,
  });
  
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late APIRunner helper;
  
  @override
  void initState() {
    helper = widget.apiRunner ?? APIRunner();
    initialize();
    super.initState();
  }
}
```

### Priority 2: Profile Widget Layout

**Issue**: Fixed-height carousels overflow test viewport

**Solutions:**
1. Wrap body in SingleChildScrollView
2. Use Expanded widgets for flex layout
3. Adjust carousel heights

## Test Coverage Statistics

- **Total Widget Test Files**: 7
- **Fully Passing**: 3 files (movie_card, login, helper_widgets partial)
- **Partial/Conditional**: 1 file (movie_detail)
- **Skipped**: 1 file (movie_list)
- **Failing**: 2 files (search, profile)

- **Total Test Cases**: ~80
- **Passing Tests**: ~46
- **Skipped Tests**: ~1
- **Failing Tests**: ~33

## Dependencies

```yaml
dev_dependencies:
  flutter_test: sdk: flutter
  mockito: ^5.4.4
  network_image_mock: ^2.1.1
```

## Best Practices Demonstrated

1. ✅ Using `network_image_mock` for image testing
2. ✅ Testing widgets in isolation
3. ✅ Comprehensive edge case coverage
4. ✅ Clear test descriptions
5. ✅ Proper setUp/tearDown patterns
6. ✅ Testing user interactions
7. ✅ Testing form validation

## Next Steps

1. **Refactor for DI**: Update MovieList, Search, MovieDetail
2. **Fix Profile Layout**: Add scrolling/adjust heights
3. **Enable Skipped Tests**: Once refactoring complete
4. **Add Widget Keys**: For more reliable test finding
5. **Golden Tests**: Add visual regression tests
6. **Navigation Tests**: Test screen transitions
7. **Integration Tests**: Full user flows

## Known Limitations

- Widgets that make API calls cannot be fully tested without refactoring
- Navigation to detail screens skipped (MovieDetail makes API calls)
- Profile widget layout issues in test viewport
- Some widgets lack Keys for reliable test finding

## Success Metrics

- ✓ 46+ widget tests passing
- ✓ Core reusable components fully tested (MovieCard)
- ✓ Form validation fully tested (Login)
- ✓ Layout widgets tested (helper widgets)
- ⊘ Full-screen widgets need refactoring
- ⊘ API-dependent widgets need dependency injection

---

**Overall Status**: 🟡 **PARTIAL SUCCESS**

Core UI components are well-tested. Full-screen widgets requiring API calls need refactoring for complete test coverage.

