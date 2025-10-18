import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('User Registration Form Widget Tests', () {
    testWidgets('shows error messages when fields are empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('shows error for invalid email and weak password', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      // Fill invalid data
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'F',
      ); // name too short
      await tester.enterText(find.byType(TextFormField).at(1), 'invalidEmail');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        '123',
      ); // weak password
      await tester.enterText(
        find.byType(TextFormField).at(3),
        '123',
      ); // confirm password

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('shows success message when valid data is entered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'Fatma Atef');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'fatma@gmail.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Fatma@123');
      await tester.enterText(find.byType(TextFormField).at(3), 'Fatma@123');

      await tester.tap(find.text('Register'));
      await tester.pump(const Duration(seconds: 3)); 

      expect(find.text('Registration successful!'), findsOneWidget);
    });
  });
}
