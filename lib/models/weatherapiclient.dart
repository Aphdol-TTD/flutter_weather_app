import 'dart:convert';

import 'package:flutter_weather_app1/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherApiClient {
   //static String city='calgary';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';


  Future<Weather> fetchWeatherData(String city) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=3fa225eb281b5fe1655f599cfdd17cab&units=metric';
    final response = await http.get(Uri.parse(url));
    print(response);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}
