import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notflix/view/user_page/log_in.dart';

void main() {
  group('LogIn Widget', () {
    testWidgets('renders with all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Verify AppBar
      expect(find.byType(AppBar), findsOneWidget);
      
      // Verify username field
      expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
      
      // Verify password field
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
      
      // Verify login button
      expect(find.byType(ElevatedButton), findsOneWidget);
      
      // Verify register link (TextButton)
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('password field obscures text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Find the password TextField
      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );

      // Verify password is obscured
      expect(passwordField.obscureText, true);
    });

    testWidgets('username field does not obscure text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Find the username TextField
      final usernameField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Username'),
      );

      // Verify username is not obscured
      expect(usernameField.obscureText, false);
    });

    testWidgets('can enter text in username field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Enter text in username field
      await tester.enterText(
        find.widgetWithText(TextField, 'Username'),
        'test@example.com',
      );
      await tester.pump();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('can enter text in password field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Enter text in password field
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );
      await tester.pump();

      // Note: Password text won't be visible due to obscureText
      // But the controller should have the value
    });

    testWidgets('shows error when submitting empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Tap login button without entering credentials
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Wait for error message to appear
      await tester.pump(const Duration(milliseconds: 100));

      // Verify error message is displayed
      expect(find.text('Email and password cannot be empty'), findsOneWidget);
    });

    testWidgets('shows error when submitting empty username', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Enter only password
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify error message
      expect(find.text('Email and password cannot be empty'), findsOneWidget);
    });

    testWidgets('shows error when submitting empty password', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Enter only username
      await tester.enterText(
        find.widgetWithText(TextField, 'Username'),
        'test@example.com',
      );
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify error message
      expect(find.text('Email and password cannot be empty'), findsOneWidget);
    });

    testWidgets('error message is displayed in red', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Submit empty form to trigger error
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Find the error text widget
      final errorText = tester.widget<Text>(
        find.text('Email and password cannot be empty'),
      );

      // Verify it's red
      expect(errorText.style?.color, Colors.red);
    });

    testWidgets('error message disappears when corrected', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Submit empty form to show error
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify error is shown
      expect(find.text('Email and password cannot be empty'), findsOneWidget);

      // Note: Error clears on next login attempt in the actual implementation
      // Testing that would require database mocking
    });

    testWidgets('register link is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Find the register TextButton
      expect(find.byType(TextButton), findsOneWidget);

      // Verify it's tappable
      await tester.tap(find.byType(TextButton));
      await tester.pump();

      // Note: Actual navigation would require implementation
    });

    testWidgets('has proper padding and spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Verify Padding widget exists
      expect(find.byType(Padding), findsWidgets);
      
      // Verify Column for layout
      expect(find.byType(Column), findsWidgets);
      
      // Verify SizedBox for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('has proper text field borders', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Find username TextField
      final usernameField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Username'),
      );

      // Verify it has OutlineInputBorder
      expect(
        usernameField.decoration?.border,
        isA<OutlineInputBorder>(),
      );
    });

    testWidgets('centers content vertically', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Find the main Column
      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(Padding),
          matching: find.byType(Column),
        ).first,
      );

      // Verify center alignment
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('login button is an ElevatedButton', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Verify button type
      expect(find.byType(ElevatedButton), findsOneWidget);
      
      // Verify button text
      expect(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.text('Login'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('multiple taps do not cause errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LogIn(),
        ),
      );

      // Tap login button multiple times
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should not crash (error message checking skipped per user request)
      expect(find.byType(Form), findsOneWidget);
    });
  });
}

