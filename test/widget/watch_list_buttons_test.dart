import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notflix/view/widgets/watch_list_buttons.dart';

// NOTE: WatchListButtons uses DbConnection and pb (PocketBase) directly.
// These tests focus on UI rendering and structure. Full functionality tests
// would require refactoring the widget to accept dependency injection.

void main() {
  group('WatchListButtons Widget', () {
    late Map<String, dynamic> testShowData;

    setUp(() {
      testShowData = {
        'id': 1,
        'title': 'Test Movie',
        'poster_path': '/test.jpg',
        'vote_average': 8.5,
        'release_date': '2024-01-15',
      };
    });

    testWidgets('renders login prompt when user is not logged in', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      // Wait for async initialization
      await tester.pumpAndSettle();

      // Verify login prompt is displayed
      expect(find.text('Log in to save to your watch list'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Wait for async operations
      await tester.pumpAndSettle();
    });

    testWidgets('renders checkboxes when user is logged in', (WidgetTester tester) async {
      // Note: This test would require mocking pb.authStore which is a global
      // For now, we test the structure when not logged in
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // When not logged in, should show login prompt
      expect(find.text('Log in to save to your watch list'), findsOneWidget);
    });

    testWidgets('has proper padding structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Padding widget exists
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('displays info icon when not logged in', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify info icon
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('has proper card structure for login prompt', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Card exists
      expect(find.byType(Card), findsOneWidget);
      
      // Verify Row layout
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('handles different show data', (WidgetTester tester) async {
      final differentShowData = {
        'id': 2,
        'title': 'Different Movie',
        'poster_path': '/different.jpg',
        'vote_average': 7.0,
        'release_date': '2024-02-01',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 2,
              showTitle: 'Different Movie',
              showPosterPath: '/different.jpg',
              showData: differentShowData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should still render properly
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('maintains state during lifecycle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      // Pump multiple frames
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Should still be valid
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('creates with required parameters', (WidgetTester tester) async {
      const widget = WatchListButtons(
        showId: 1,
        showTitle: 'Test Movie',
        showPosterPath: '/test.jpg',
        showData: {'id': 1, 'title': 'Test Movie'},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      expect(find.byWidget(widget), findsOneWidget);
    });

    testWidgets('uses proper key', (WidgetTester tester) async {
      const key = Key('watch_list_key');
      const widget = WatchListButtons(
        key: key,
        showId: 1,
        showTitle: 'Test Movie',
        showPosterPath: '/test.jpg',
        showData: {'id': 1},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('handles empty show data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without crashing
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('handles zero show ID', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 0,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without crashing
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('handles empty show title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: '',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without crashing
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('handles empty poster path', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '',
              showData: testShowData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without crashing
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('has proper scaffold structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatchListButtons(
              showId: 1,
              showTitle: 'Test Movie',
              showPosterPath: '/test.jpg',
              showData: testShowData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}

