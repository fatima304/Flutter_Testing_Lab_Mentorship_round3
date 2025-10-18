// test/weather_conversion_test.dart
import 'package:flutter_testing_lab/widgets/weather_display.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Temperature conversions', () {
    test('Celsius to Fahrenheit', () {
      expect(celsiusToFahrenheit(0), 32);
      expect(celsiusToFahrenheit(100), 212);
      expect(celsiusToFahrenheit(-40), -40);
    });

    test('Fahrenheit to Celsius', () {
      expect(fahrenheitToCelsius(32).round(), 0);
      expect(fahrenheitToCelsius(212).round(), 100);
      expect(fahrenheitToCelsius(-40).round(), -40);
    });

    test('Decimal edge cases', () {
      expect(celsiusToFahrenheit(37.5).toStringAsFixed(1), '99.5');
      expect(fahrenheitToCelsius(99.5).toStringAsFixed(1), '37.5');
    });
  });

  group('WeatherData - JSON Handling', () {
    test('Handles null gracefully', () {
      expect(() => WeatherData.fromJson(null), throwsA(isA<FormatException>()));
    });

    test('Throws on incomplete data', () {
      final data = {'city': 'Cairo', 'temperature': 30.0};
      expect(() => WeatherData.fromJson(data), throwsA(isA<FormatException>()));
    });

    test('Throws on wrong data type', () {
      final data = {
        'city': 'Cairo',
        'temperature': '30.0', 
        'description': 'Sunny',
        'humidity': 65,
        'windSpeed': 5.0,
        'icon': '☀️',
      };
      expect(() => WeatherData.fromJson(data), throwsA(isA<FormatException>()));
    });

    test('Parses valid JSON correctly', () {
      final data = {
        'city': 'TestCity',
        'temperature': 20,
        'description': 'Clear',
        'humidity': 50,
        'windSpeed': 3.5,
        'icon': '☀️',
      };

      final wd = WeatherData.fromJson(data);
      expect(wd.city, 'TestCity');
      expect(wd.temperatureCelsius, 20.0);
      expect(wd.description, 'Clear');
      expect(wd.humidity, 50);
      expect(wd.windSpeed, 3.5);
      expect(wd.icon, '☀️');
    });
  });
}
