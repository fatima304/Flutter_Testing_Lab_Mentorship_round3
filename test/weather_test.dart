import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('WeatherDisplay - Temperature Conversion', () {
    test('Converts Celsius to Fahrenheit correctly', () {
      final widgetState = WeatherDisplayState();
      expect(widgetState.celsiusToFahrenheit(0), 32);
      expect(widgetState.celsiusToFahrenheit(100), 212);
    });

    test('Converts Fahrenheit to Celsius correctly', () {
      final widgetState = WeatherDisplayState();
      expect(widgetState.fahrenheitToCelsius(32).round(), 0);
      expect(widgetState.fahrenheitToCelsius(212).round(), 100);
    });
  });

  test('Edge Case: Decimal temperatures conversion', () {
    final widgetState = WeatherDisplayState();
    final resultF = widgetState.celsiusToFahrenheit(37.5);
    expect(resultF.toStringAsFixed(1), '99.5');

    final resultC = widgetState.fahrenheitToCelsius(99.5);
    expect(resultC.toStringAsFixed(1), '37.5');
  });

  group('WeatherDisplay - Null & Incomplete Data Handling', () {
    test('Handles null API response gracefully', () async {
      final state = WeatherDisplayState();
      final data = await state.fetchWeatherData('Invalid City');
      expect(data, null);
    });

    test('Throws FormatException on incomplete data', () {
      final incompleteData = {'city': 'Cairo', 'temperature': 30.0};
      expect(
        () => WeatherData.fromJson(incompleteData),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
