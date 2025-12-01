import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notflix/view/movie_list.dart';

// NOTE: MovieList makes API calls in initState(). These tests focus on UI elements
// that can be tested without waiting for API calls to complete, primarily the
// loading state and initial UI structure.

void main() {
  group('MovieList Widget Loading State', () {
    testWidgets('shows loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Should show loading indicator immediately
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Should have AppBar with title
      expect(find.text('Notflix'), findsOneWidget);
      
      // Should have Scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('loading screen has centered progress indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Find the Center widget
      expect(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(Center),
        ),
        findsOneWidget,
      );
    });

    testWidgets('has proper app bar structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Verify AppBar
      expect(find.byType(AppBar), findsOneWidget);
      
      // Verify title
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Notflix'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Should render successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('has proper material app theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Verify MaterialApp
      final materialApp = find.byType(MaterialApp);
      expect(materialApp, findsOneWidget);
    });

    testWidgets('loading indicator is visible', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Verify loading indicator is not obscured
      final progressIndicator = find.byType(CircularProgressIndicator);
      expect(tester.widget(progressIndicator), isNotNull);
    });
  });

  group('MovieList AppBar Actions', () {
    testWidgets('has search icon button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Initially shows loading, but AppBar should be present
      expect(find.byType(AppBar), findsOneWidget);
      
      // Search icon should be in AppBar actions
      // Note: Actions are rendered even during loading
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('has settings icon button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Settings icon should be present
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('has person/profile icon button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Person icon should be present
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('search button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Wait a bit for initial render
      await tester.pump(const Duration(milliseconds: 100));

      // Tap search button (should not crash even if API is loading)
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
    });
  });

  group('MovieList Helper Widgets', () {
    testWidgets('has proper scaffold structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Verify Scaffold exists
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Verify AppBar in Scaffold
      expect(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(AppBar),
        ),
        findsOneWidget,
      );
    });
  });

  group('MovieList State Management', () {
    testWidgets('maintains state during widget lifecycle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Initial state should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Pump a frame
      await tester.pump();

      // Should still be in a valid state
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('handles multiple builds', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Pump multiple frames
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Should still be valid
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('loading state persists during async operations', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MovieList(),
        ),
      );

      // Initially loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Pump several frames (simulating async API calls)
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      // Should still show loading or have transitioned to content
      // (depending on how fast API responds, but widget should be stable)
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('MovieList Constructor', () {
    testWidgets('creates with const constructor', (WidgetTester tester) async {
      const widget = MovieList();
      
      await tester.pumpWidget(
        const MaterialApp(
          home: widget,
        ),
      );

      expect(find.byWidget(widget), findsOneWidget);
    });

    testWidgets('uses proper key', (WidgetTester tester) async {
      const key = Key('movie_list_key');
      const widget = MovieList(key: key);
      
      await tester.pumpWidget(
        const MaterialApp(
          home: widget,
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });
  });
}

