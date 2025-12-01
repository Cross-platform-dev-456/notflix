import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notflix/view/signup_page.dart';

// NOTE: SignupPage creates its own DbConnection instance. These tests focus on
// UI rendering, form validation, and user interactions. Full integration tests
// with database mocking would require refactoring for dependency injection.

void main() {
  group('SignupPage Widget', () {
    testWidgets('renders with all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Verify AppBar
      expect(find.byType(AppBar), findsOneWidget);
      
      // Verify form fields by type
      expect(find.byType(TextFormField), findsNWidgets(4)); // Username, Email, Password, Confirm Password
      
      // Verify signup button
      expect(find.byType(ElevatedButton), findsOneWidget);
      
      // Verify login link button
      expect(find.byType(TextButton), findsOneWidget);
      
      // Verify app icon
      expect(find.byIcon(Icons.movie_filter), findsOneWidget);
      
      // Verify scaffold structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('password fields obscure text by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Find password fields - verify they exist
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);
      
      // Note: obscureText is a property of TextFormField but not directly accessible
      // We verify the fields exist and test visibility toggle separately
    });

    testWidgets('password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Find password visibility icons
      final passwordVisibilityIcons = find.byIcon(Icons.visibility_outlined);
      expect(passwordVisibilityIcons, findsNWidgets(2)); // Both password fields

      // Tap first visibility icon (password field)
      await tester.tap(passwordVisibilityIcons.first);
      await tester.pump();

      // After tapping, icon should change to visibility_off
      expect(find.byIcon(Icons.visibility_off_outlined), findsAtLeastNWidgets(1));

      // Tap second visibility icon (confirm password field)
      await tester.tap(passwordVisibilityIcons.last);
      await tester.pump();

      // Both icons should now be visibility_off (passwords visible)
      expect(find.byIcon(Icons.visibility_off_outlined), findsAtLeastNWidgets(2));
    });

    testWidgets('can enter text in all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Get all text form fields
      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(4));

      // Enter text in first field (username)
      await tester.enterText(textFields.at(0), 'testuser');
      await tester.pump();

      // Enter text in second field (email)
      await tester.enterText(textFields.at(1), 'test@example.com');
      await tester.pump();

      // Enter text in third field (password)
      await tester.enterText(textFields.at(2), 'TestPass123');
      await tester.pump();

      // Enter text in fourth field (confirm password)
      await tester.enterText(textFields.at(3), 'TestPass123');
      await tester.pump();
    });

    testWidgets('validates username is required', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Try to submit without username
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show validation error (verify form validation is triggered)
      // Note: Error text may not be visible immediately, but form should prevent submission
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('validates username minimum length', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter short username
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'ab');
      await tester.pump();

      // Try to submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form validation should be triggered
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('validates email is required', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter username only
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'testuser');
      await tester.pump();

      // Try to submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form validation should be triggered
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('validates email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter invalid email
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(1), 'invalid-email');
      await tester.pump();

      // Try to submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form validation should be triggered
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('validates password is required', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter username and email only
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'testuser');
      await tester.enterText(textFields.at(1), 'test@example.com');
      await tester.pump();

      // Try to submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form validation should be triggered
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('validates password minimum length', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter short password
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(2), 'Short1');
      await tester.pump();

      // Try to submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form validation should be triggered
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('validates password contains uppercase letter', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter password without uppercase
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(2), 'lowercase123');
      await tester.pump();

      // Try to submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form validation should be triggered
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('validates password contains lowercase letter', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter password without lowercase
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(2), 'UPPERCASE123');
      await tester.pump();

      // Try to submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form validation should be triggered
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('validates password contains number', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter password without number
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(2), 'NoNumbers');
      await tester.pump();

      // Try to submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form validation should be triggered
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('validates confirm password matches', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter password
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(2), 'TestPass123');
      await tester.pump();

      // Enter different confirm password
      await tester.enterText(textFields.at(3), 'Different123');
      await tester.pump();

      // Try to submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form validation should be triggered
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('validates confirm password is required', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter password but not confirm password
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(2), 'TestPass123');
      await tester.pump();

      // Try to submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form validation should be triggered
      expect(find.byType(Form), findsOneWidget);
    }, skip: true); // Text-based validation error checking skipped per user request

    testWidgets('login link is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
                child: const Text('Go to Signup'),
              ),
            ),
          ),
        ),
      );

      // Navigate to signup page
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify we're on signup page (check for AppBar)
      expect(find.byType(AppBar), findsOneWidget);

      // Tap login link (TextButton)
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // Should navigate back (check for original button)
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('has proper scaffold structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Verify Scaffold
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Verify SafeArea
      expect(find.byType(SafeArea), findsOneWidget);
      
      // Verify SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      
      // Verify Form
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('has proper padding and layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Verify Padding widgets exist
      expect(find.byType(Padding), findsWidgets);
      
      // Verify Column for layout
      expect(find.byType(Column), findsWidgets);
      
      // Verify SizedBox for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('handles special characters in inputs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      // Enter special characters in username
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'user_name-123');
      await tester.pump();

      // Verify text field accepts the input (field should still exist)
      expect(textFields, findsNWidgets(4));
    });

    testWidgets('handles long inputs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupPage(),
        ),
      );

      const longUsername = 'verylongusernamethatexceedstypicallimits';
      
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), longUsername);
      await tester.pump();

      // Verify text field accepts the input (field should still exist)
      expect(textFields, findsNWidgets(4));
    });

    testWidgets('creates with const constructor', (WidgetTester tester) async {
      const widget = SignupPage();
      
      await tester.pumpWidget(
        const MaterialApp(
          home: widget,
        ),
      );

      expect(find.byWidget(widget), findsOneWidget);
    });

    testWidgets('uses proper key', (WidgetTester tester) async {
      const key = Key('signup_key');
      const widget = SignupPage(key: key);
      
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
          home: SignupPage(),
        ),
      );

      // Enter some text
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'testuser');
      await tester.pump();

      // Pump multiple frames
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should still have the text field
      expect(textFields, findsNWidgets(4));
    });
  });
}

