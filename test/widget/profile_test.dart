import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notflix/view/user_page/profile.dart';

void main() {
  group('Profile Widget', () {
    testWidgets('renders with AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Profile(),
        ),
      );

      // Verify Scaffold
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Verify AppBar
      expect(find.byType(AppBar), findsOneWidget);
      
      // Verify Profile title
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('has back button in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Profile(),
        ),
      );

      // Verify back arrow icon
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      
      // Verify it's an IconButton
      expect(
        find.ancestor(
          of: find.byIcon(Icons.arrow_back),
          matching: find.byType(IconButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets('back button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Profile()),
                  );
                },
                child: const Text('Go to Profile'),
              ),
            ),
          ),
        ),
      );

      // Navigate to profile
      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();

      // Verify we're on profile page
      expect(find.text('Profile'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Should be back
      expect(find.text('Go to Profile'), findsOneWidget);
    });

    testWidgets('displays Watch-List section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Profile(),
        ),
      );

      // Verify Watch-List text
      expect(find.text('Watch-List'), findsOneWidget);
    });

    testWidgets('displays Recently Watched section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Profile(),
        ),
      );

      // Verify Recently Watched text
      expect(find.text('Recently Watched'), findsOneWidget);
    });

    testWidgets('has proper padding and layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Profile(),
        ),
      );

      // Verify Padding widget exists
      expect(find.byType(Padding), findsWidgets);
      
      // Verify Column for vertical layout
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('centers content vertically', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Profile(),
        ),
      );

      // Find the main Column
      final columns = tester.widgetList<Column>(find.byType(Column));
      
      // At least one should have center alignment
      expect(columns.any((col) => col.mainAxisAlignment == MainAxisAlignment.center), true);
    });

    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Profile(),
        ),
      );

      // Should render successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('creates with const constructor', (WidgetTester tester) async {
      const widget = Profile();
      
      await tester.pumpWidget(
        const MaterialApp(
          home: widget,
        ),
      );

      expect(find.byWidget(widget), findsOneWidget);
    });

    testWidgets('uses proper key', (WidgetTester tester) async {
      const key = Key('profile_key');
      const widget = Profile(key: key);
      
      await tester.pumpWidget(
        const MaterialApp(
          home: widget,
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('maintains state during lifecycle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Profile(),
        ),
      );

      // Pump multiple frames
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Should still be valid
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('has Container widgets for sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Profile(),
        ),
      );

      // Verify Container widgets exist for layout
      expect(find.byType(Container), findsWidgets);
    });
  });
}

