import 'package:flutter/material.dart';

double celsiusToFahrenheit(double celsius) => (celsius * 9 / 5) + 32;
double fahrenheitToCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;

class WeatherDisplay extends StatefulWidget {
  final Future<Map<String, dynamic>?> Function(String city)? fetcher;
  final String initialCity;

  const WeatherDisplay({
    super.key,
    this.fetcher,
    this.initialCity = 'New York',
  });

  @override
  State<WeatherDisplay> createState() => WeatherDisplayState();
}

class WeatherDisplayState extends State<WeatherDisplay> {
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  bool _useFahrenheit = false;
  late String _selectedCity;

  final List<String> _cities = ['New York', 'London', 'Tokyo', 'Invalid City'];

  Future<Map<String, dynamic>?> _defaultFetchWeatherData(String city) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (city == 'Invalid City') return null;

    return {
      'city': city,
      'temperature': city == 'London' ? 15.0 : (city == 'Tokyo' ? 25.0 : 22.5),
      'description': city == 'London'
          ? 'Rainy'
          : (city == 'Tokyo' ? 'Cloudy' : 'Sunny'),
      'humidity': city == 'London' ? 85 : (city == 'Tokyo' ? 70 : 65),
      'windSpeed': city == 'London' ? 8.5 : (city == 'Tokyo' ? 5.2 : 12.3),
      'icon': city == 'London' ? '🌧️' : (city == 'Tokyo' ? '☁️' : '☀️'),
    };
  }

  Future<Map<String, dynamic>?> fetchWeatherData(String city) async {
    final fetch = widget.fetcher ?? _defaultFetchWeatherData;
    return await fetch(city);
  }

  Future<void> loadWeather() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
        _weatherData = null;
      });
    }

    try {
      final data = await fetchWeatherData(_selectedCity);

      if (data == null) {
        if (mounted) {
          setState(() {
            _error = 'No weather data available for $_selectedCity';
            _isLoading = false;
          });
        }
        return;
      }

      final weather = WeatherData.fromJson(data);
      if (mounted) {
        setState(() {
          _weatherData = weather;
          _isLoading = false;
        });
      }
    } on FormatException catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Data error: ${e.message}';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load weather data';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialCity;
    if (!_cities.contains(_selectedCity)) {
      _cities.add(_selectedCity);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => loadWeather());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('City: '),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedCity,
                  isExpanded: true,
                  items: _cities
                      .map(
                        (city) =>
                            DropdownMenuItem(value: city, child: Text(city)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCity = value;
                      });
                      loadWeather();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: loadWeather,
                child: const Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Temperature Unit:'),
              const SizedBox(width: 10),
              Switch(
                value: _useFahrenheit,
                onChanged: (value) {
                  setState(() {
                    _useFahrenheit = value;
                  });
                },
              ),
              Text(_useFahrenheit ? 'Fahrenheit' : 'Celsius'),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading && _error == null)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          else if (_weatherData != null)
            _buildWeatherCard(),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    final displayTemp = _useFahrenheit
        ? '${celsiusToFahrenheit(_weatherData!.temperatureCelsius).toStringAsFixed(1)}°F'
        : '${_weatherData!.temperatureCelsius.toStringAsFixed(1)}°C';

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(_weatherData!.icon, style: const TextStyle(fontSize: 48)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weatherData!.city,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _weatherData!.description,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                displayTemp,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWeatherDetail(
                  'Humidity',
                  '${_weatherData!.humidity}%',
                  Icons.water_drop,
                ),
                _buildWeatherDetail(
                  'Wind Speed',
                  '${_weatherData!.windSpeed} km/h',
                  Icons.air,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class WeatherData {
  final String city;
  final double temperatureCelsius;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;

  WeatherData({
    required this.city,
    required this.temperatureCelsius,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw const FormatException('Data is null.');
    }

    if (!json.containsKey('city') ||
        !json.containsKey('temperature') ||
        !json.containsKey('description') ||
        !json.containsKey('humidity') ||
        !json.containsKey('windSpeed') ||
        !json.containsKey('icon')) {
      throw const FormatException('Missing required fields in JSON response.');
    }

    try {
      final city = json['city'] as String;
      final temperature = (json['temperature'] as num).toDouble();
      final description = json['description'] as String;
      final humidity = (json['humidity'] as num).toInt();
      final windSpeed = (json['windSpeed'] as num).toDouble();
      final icon = json['icon'] as String;

      return WeatherData(
        city: city,
        temperatureCelsius: temperature,
        description: description,
        humidity: humidity,
        windSpeed: windSpeed,
        icon: icon,
      );
    } on TypeError {
      throw const FormatException('Invalid data types in JSON response.');
    } catch (e) {
      throw const FormatException('Missing required fields in JSON response.');
    }
  }
}
