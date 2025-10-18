import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  testWidgets('WeatherDisplay shows loading then data', (
    WidgetTester tester,
  ) async {
    Future<Map<String, dynamic>?> mockFetcher(String city) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return {
        'city': city,
        'temperature': 25.0,
        'description': 'Sunny',
        'humidity': 60,
        'windSpeed': 10.0,
        'icon': '☀️',
      };
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherDisplay(fetcher: mockFetcher, initialCity: 'TestCity'),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('TestCity'), findsNWidgets(2));
    expect(find.text('Sunny'), findsOneWidget);
    expect(find.textContaining('25.0'), findsOneWidget);
  });
}
