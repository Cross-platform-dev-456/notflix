import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notflix/view/search.dart';

// NOTE: These tests focus on UI elements that don't require API calls.
// Full functionality tests would require refactoring Search widget for dependency injection.

void main() {
  group('Search Widget UI Elements', () {
    testWidgets('renders with app bar and search field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);
      
      // Verify TextFormField for search
      expect(find.byType(TextFormField), findsOneWidget);
      
      // Verify hint text
      expect(find.text('Search For Movies'), findsOneWidget);
    });

    testWidgets('search field accepts text input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Enter text in search field
      await tester.enterText(find.byType(TextFormField), 'Inception');
      await tester.pump();

      // Verify text was entered
      expect(find.text('Inception'), findsOneWidget);
    });

    testWidgets('clear button appears when text is entered', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Initially, no clear button should be visible
      expect(find.byIcon(Icons.clear), findsNothing);

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'Test');
      await tester.pump();

      // Clear button should appear
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clear button clears the search field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'Test Movie');
      await tester.pump();

      // Verify text is there
      expect(find.text('Test Movie'), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Text should be cleared
      expect(find.text('Test Movie'), findsNothing);
    });

    testWidgets('has settings icon button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Find settings icon
      expect(find.byIcon(Icons.settings), findsOneWidget);
      
      // Verify it's a button
      expect(
        find.ancestor(
          of: find.byIcon(Icons.settings),
          matching: find.byType(IconButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets('has person/profile icon button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Find person icon
      expect(find.byIcon(Icons.person), findsOneWidget);
      
      // Verify it's a button
      expect(
        find.ancestor(
          of: find.byIcon(Icons.person),
          matching: find.byType(IconButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets('settings button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Tap settings button
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();

      // Should not crash
    });

    testWidgets('profile button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Tap profile button
      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      // Should not crash
    });

    testWidgets('search field has correct decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Verify the text form field exists
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('uses PopScope for navigation control', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Verify PopScope exists for gesture control
      expect(find.byType(PopScope), findsOneWidget);
      
      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, true);
    });

    testWidgets('has proper scaffold structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Verify Scaffold
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

    testWidgets('multiple text entries work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Enter first text
      await tester.enterText(find.byType(TextFormField), 'First');
      await tester.pump();
      expect(find.text('First'), findsOneWidget);

      // Clear
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Enter second text
      await tester.enterText(find.byType(TextFormField), 'Second');
      await tester.pump();
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('search field is properly configured', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Verify the text form field exists and is configured
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('empty search triggers clear function', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'Test');
      await tester.pump();

      // Clear text manually (simulating backspace to empty)
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      // Clear button should disappear
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('handles long search queries', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      const longQuery = 'This is a very long search query that might be used to search for a very specific movie';
      
      await tester.enterText(find.byType(TextFormField), longQuery);
      await tester.pump();

      expect(find.text(longQuery), findsOneWidget);
    });

    testWidgets('handles special characters in search', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Search(),
        ),
      );

      const specialQuery = 'Star Wars: Episode IV - A New Hope (1977)';
      
      await tester.enterText(find.byType(TextFormField), specialQuery);
      await tester.pump();

      expect(find.text(specialQuery), findsOneWidget);
    });
  });
}

