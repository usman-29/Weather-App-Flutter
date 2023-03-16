import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather.dart';

class WeatherModel {
  var apiKey = "APIKEY";
  double lat;
  double lon;
  WeatherModel({required this.lat, required this.lon});

  Future<WModel> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey'));
      if (response.statusCode == 200) {
        var send = WModel.fromJson(jsonDecode(response.body));
        return send;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
