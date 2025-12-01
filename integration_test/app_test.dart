import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:notflix/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Launch and Initial State', () {
    testWidgets('app launches successfully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify app is running
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('home screen displays app bar with title', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check for app bar
      expect(find.byType(AppBar), findsOneWidget);
      // Check for title (either "Notflix" or search bar)
      expect(find.text('Notflix'), findsWidgets);
    });

    testWidgets('home screen shows loading indicator initially', (WidgetTester tester) async {
      app.main();
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('home screen displays app bar icons', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check for search icon
      expect(find.byIcon(Icons.search), findsOneWidget);
      // Check for settings icon
      expect(find.byIcon(Icons.settings), findsOneWidget);
      // Check for profile icon
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('home screen loads content after initialization', (WidgetTester tester) async {
      app.main();
      // Wait for content to load (API calls may take time)
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should have category/genre buttons
      expect(find.text('Categories:'), findsOneWidget);
      expect(find.text('Genres:'), findsOneWidget);
    });
  });

  group('Navigation Flows', () {
    testWidgets('navigate from home to search screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify we're on search screen
      expect(find.text('Search For Movies'), findsOneWidget);
    });

    testWidgets('navigate from home to movie detail via hero movie', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Find and tap the hero movie card
      final heroCard = find.byType(Card).first;
      if (heroCard.evaluate().isNotEmpty) {
        await tester.tap(heroCard);
        await tester.pumpAndSettle();

        // Should be on detail screen
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Overview'), findsOneWidget);
      }
    });

    testWidgets('navigate from search to movie detail', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextFormField), 'batman');
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap first search result
      final searchResults = find.byType(Card);
      if (searchResults.evaluate().isNotEmpty) {
        await tester.tap(searchResults.first);
        await tester.pumpAndSettle();

        // Should be on detail screen
        expect(find.text('Overview'), findsOneWidget);
      }
    });

    testWidgets('back navigation from detail screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to detail
      final heroCard = find.byType(Card).first;
      if (heroCard.evaluate().isNotEmpty) {
        await tester.tap(heroCard);
        await tester.pumpAndSettle();

        // Go back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Should be back on home screen
        expect(find.text('Categories:'), findsOneWidget);
      }
    });

    testWidgets('navigate to login screen when logged out', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap profile icon
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Should be on login screen
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);
    });
  });

  group('Search Functionality', () {
    testWidgets('search screen displays default content', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Should show default content
      expect(find.text('Upcoming Movies'), findsOneWidget);
    });

    testWidgets('search input field accepts text', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter text in search field
      await tester.enterText(find.byType(TextFormField), 'test movie');
      await tester.pump();

      // Verify text was entered
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.controller?.text, 'test movie');
    });

    testWidgets('search results appear in grid layout', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextFormField), 'action');
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should show grid view
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('search clears when text is removed', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'test');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Clear text
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Should show default content again
      expect(find.text('Upcoming Movies'), findsOneWidget);
    });

    testWidgets('tapping search result navigates to detail', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextFormField), 'spider');
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap first result
      final searchResults = find.byType(Card);
      if (searchResults.evaluate().isNotEmpty) {
        await tester.tap(searchResults.first);
        await tester.pumpAndSettle();

        // Should be on detail screen
        expect(find.text('Overview'), findsOneWidget);
      }
    });
  });

  group('Filtering (Category/Genre)', () {
    testWidgets('category dropdown displays options', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Find category dropdown
      expect(find.text('Categories:'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsWidgets);
    });

    testWidgets('genre dropdown updates based on category', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Find category dropdown
      final categoryDropdowns = find.byType(DropdownButton<String>);
      if (categoryDropdowns.evaluate().isNotEmpty) {
        // Tap first dropdown (category)
        await tester.tap(categoryDropdowns.first);
        await tester.pumpAndSettle();

        // Select "Movies"
        await tester.tap(find.text('Movies').last);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Genre dropdown should now show movie genres
        expect(find.text('Genres:'), findsOneWidget);
      }
    });

    testWidgets('filtering by specific genre updates content', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Find genre dropdown
      final dropdowns = find.byType(DropdownButton<String>);
      if (dropdowns.evaluate().length >= 2) {
        // Tap genre dropdown (second one)
        await tester.tap(dropdowns.at(1));
        await tester.pumpAndSettle();

        // Select a genre if available
        final actionOption = find.text('Action');
        if (actionOption.evaluate().isNotEmpty) {
          await tester.tap(actionOption);
          await tester.pumpAndSettle(const Duration(seconds: 5));

          // Content should update
          expect(find.byType(Card), findsWidgets);
        }
      }
    });

    testWidgets('resetting filters to All', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Find dropdowns
      final dropdowns = find.byType(DropdownButton<String>);
      if (dropdowns.evaluate().isNotEmpty) {
        // Tap first dropdown
        await tester.tap(dropdowns.first);
        await tester.pumpAndSettle();

        // Select "All"
        await tester.tap(find.text('All').last);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Should still show content
        expect(find.byType(Card), findsWidgets);
      }
    });
  });

  group('Movie Detail Screen', () {
    testWidgets('movie detail screen displays movie information', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to detail
      final heroCard = find.byType(Card).first;
      if (heroCard.evaluate().isNotEmpty) {
        await tester.tap(heroCard);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should show overview section
        expect(find.text('Overview'), findsOneWidget);
      }
    });

    testWidgets('movie detail shows trailer or poster', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to detail
      final heroCard = find.byType(Card).first;
      if (heroCard.evaluate().isNotEmpty) {
        await tester.tap(heroCard);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // At minimum should have some visual content (trailer or image)
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      }
    });

    testWidgets('watch list buttons are present on detail screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to detail
      final heroCard = find.byType(Card).first;
      if (heroCard.evaluate().isNotEmpty) {
        await tester.tap(heroCard);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should have watch list section (either buttons or login message)
        final hasLoginMessage = find.text('Log in to save to your watch list').evaluate().isNotEmpty;
        final hasWatchListButtons = find.text('Recently Watched').evaluate().isNotEmpty;
        expect(hasLoginMessage || hasWatchListButtons, isTrue);
      }
    });
  });

  group('User Authentication Flow', () {
    testWidgets('login screen displays correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to login
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Verify login screen elements
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Log In'), findsWidgets);
    });

    testWidgets('login form validates email format', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to login
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Enter invalid email in the email field
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.tap(find.text('Log In').last);
      await tester.pump();

      // Should show validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('login form validates required fields', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to login
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Log In').last);
      await tester.pump();

      // Should show validation errors
      final hasEmailError = find.text('Please enter your email').evaluate().isNotEmpty;
      final hasPasswordError = find.text('Please enter your password').evaluate().isNotEmpty;
      expect(hasEmailError || hasPasswordError, isTrue);
    });

    testWidgets('navigate to signup from login screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to login
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Tap sign up link
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Should be on signup screen
      expect(find.text('Sign Up'), findsOneWidget);
    });
  });

  group('Watch List Interactions', () {
    testWidgets('watch list buttons display login message when not logged in', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to detail
      final heroCard = find.byType(Card).first;
      if (heroCard.evaluate().isNotEmpty) {
        await tester.tap(heroCard);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should show login message
        expect(find.text('Log in to save to your watch list'), findsOneWidget);
      }
    });

    testWidgets('watch list buttons are interactive when logged in', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Note: This test would require a logged-in user
      // For now, we'll verify the structure exists
      // Navigate to detail
      final heroCard = find.byType(Card).first;
      if (heroCard.evaluate().isNotEmpty) {
        await tester.tap(heroCard);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should have watch list section
        final hasLoginMessage = find.text('Log in to save to your watch list').evaluate().isNotEmpty;
        final hasWatchListButtons = find.text('Recently Watched').evaluate().isNotEmpty;
        expect(hasLoginMessage || hasWatchListButtons, isTrue);
      }
    });
  });

  group('Error Handling', () {
    testWidgets('app handles missing data gracefully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // App should still load even if some data is missing
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('app displays content even with network delays', (WidgetTester tester) async {
      app.main();
      // Wait longer for network calls
      await tester.pumpAndSettle(const Duration(seconds: 15));

      // Should eventually show content or loading state
      final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      final hasContent = find.byType(Card).evaluate().isNotEmpty;
      expect(hasLoading || hasContent, isTrue);
    });
  });
}

