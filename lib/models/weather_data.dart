import 'dart:convert';
class WeatherData {
  late String coord;
  late String weather;
  late DateTime date;
  late String base;
  late String main;
  late String visibility;
  late String speed;
  late String clouds;
  late String timezone;
  late String name;
  late String icon;
  WeatherData(
    {
      required this.speed,
      required this.coord,
      required this.weather,
      required this.base,
      required this.main,
      required this.visibility,
      required this.timezone,
      required this.name,
      required this.icon,
      required temp,
    }
  );
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(

      temp: json['main']['temp'].toDouble(),
      main: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      coord: '',
      weather: '',
      base: '',
      visibility: '',
      timezone: '',
      name: json['name'],
      speed: '',
    );
  }
}