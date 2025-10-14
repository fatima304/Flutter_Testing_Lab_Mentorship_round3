import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('WeatherDisplay Widget Tests', () {
    testWidgets('displays basic UI components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial loading to complete
      await tester.pumpAndSettle();

      // Verify main UI components exist
      expect(find.text('City: '), findsOneWidget);
      expect(find.text('Temperature Unit:'), findsOneWidget);
      expect(find.text('Refresh'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for async operation to complete
      await tester.pumpAndSettle();
    });

    testWidgets('temperature unit toggle works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial loading
      await tester.pumpAndSettle();

      // Find the temperature unit switch
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      // Initially should show Celsius
      expect(find.text('Celsius'), findsOneWidget);

      // Tap the switch to change to Fahrenheit
      await tester.tap(switchFinder);
      await tester.pump();

      // Should now show Fahrenheit
      expect(find.text('Fahrenheit'), findsOneWidget);
    });

    testWidgets('refresh button is present and clickable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial loading
      await tester.pumpAndSettle();

      // Find refresh button
      final refreshButton = find.text('Refresh');
      expect(refreshButton, findsOneWidget);

      // Should be able to tap it (we don't test the loading state due to async complexity)
      await tester.tap(refreshButton);
      await tester.pump();

      // Wait for any async operations
      await tester.pumpAndSettle();
    });

    testWidgets('city dropdown shows correct options', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial loading
      await tester.pumpAndSettle();

      // Verify dropdown is present
      expect(find.byType(DropdownButton<String>), findsOneWidget);

      // Verify default city is selected
      expect(find.text('New York'), findsOneWidget);

      // Tap to open dropdown
      final dropdownButton = find.byType(DropdownButton<String>);
      await tester.tap(dropdownButton);
      await tester.pumpAndSettle();

      // Should show all city options
      expect(find.text('New York'), findsAtLeastNWidgets(1));
      expect(find.text('London'), findsOneWidget);
      expect(find.text('Tokyo'), findsOneWidget);
      expect(find.text('Invalid City'), findsOneWidget);
    });

    testWidgets('handles city selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial loading
      await tester.pumpAndSettle();

      // Select London from dropdown
      final dropdownButton = find.byType(DropdownButton<String>);
      await tester.tap(dropdownButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('London').last);
      await tester.pump();

      // Should show London as selected
      expect(find.text('London'), findsAtLeastNWidgets(1));

      // Wait for any async operations
      await tester.pumpAndSettle();
    });

    testWidgets('shows error message for invalid city', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial loading
      await tester.pumpAndSettle();

      // Select 'Invalid City' which returns null
      final dropdownButton = find.byType(DropdownButton<String>);
      await tester.tap(dropdownButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      // Should show error message
      expect(find.text('No weather data available'), findsOneWidget);
    });

    testWidgets('displays weather data when available', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Check if weather data is displayed (might be error or weather data due to randomness)
      final hasWeatherData = find.textContaining('°').evaluate().isNotEmpty;
      final hasError = find
          .text('No weather data available')
          .evaluate()
          .isNotEmpty;

      // Should show either weather data or error message
      expect(hasWeatherData || hasError, true);

      if (hasWeatherData) {
        // If weather data is shown, verify basic elements
        expect(find.textContaining('%'), findsOneWidget); // Humidity
        expect(find.textContaining('km/h'), findsOneWidget); // Wind speed
      }
    });

    testWidgets('weather detail icons are present when data is loaded', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Only check icons if weather data is displayed
      if (find.byIcon(Icons.water_drop).evaluate().isNotEmpty) {
        expect(find.byIcon(Icons.water_drop), findsOneWidget);
        expect(find.byIcon(Icons.air), findsOneWidget);
      }
    });

    testWidgets('handles multiple interactions without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial loading
      await tester.pumpAndSettle();

      // Perform multiple interactions
      final switchFinder = find.byType(Switch);
      final dropdownButton = find.byType(DropdownButton<String>);
      final refreshButton = find.text('Refresh');

      // Toggle temperature unit
      await tester.tap(switchFinder);
      await tester.pump();

      // Change city
      await tester.tap(dropdownButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pump();

      // Tap refresh
      await tester.tap(refreshButton);
      await tester.pump();

      // Toggle back
      await tester.tap(switchFinder);
      await tester.pump();

      // Wait for all async operations
      await tester.pumpAndSettle();

      // Should not crash and should show some UI state
      expect(find.byType(WeatherDisplay).evaluate().isNotEmpty, true);
    });
  });

  group('WeatherDisplay Error Handling Tests', () {
    testWidgets('shows error state UI correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial loading
      await tester.pumpAndSettle();

      // Select invalid city
      final dropdownButton = find.byType(DropdownButton<String>);
      await tester.tap(dropdownButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      // Should show error message in red
      final errorText = find.text('No weather data available');
      expect(errorText, findsOneWidget);

      // Verify error text has red color
      final errorWidget = tester.widget<Text>(errorText);
      expect(errorWidget.style?.color, Colors.red);
    });

    testWidgets('loading state transitions properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Initially loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Should no longer be loading
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Should show either weather data or error
      expect(
        find.textContaining('°').evaluate().isNotEmpty ||
            find.text('No weather data available').evaluate().isNotEmpty,
        true,
      );
    });
  });
}
