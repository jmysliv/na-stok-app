import 'dart:convert';

class Weather {
  final String clouds;
  final String day;
  final String dayName;
  final int temperature;

  Weather(this.clouds, this.day, this.dayName, this.temperature);

  Weather.fromJson(Map<String, dynamic> json)
    : clouds = json['clouds'],
      day = json['day'],
      dayName = json['day_name'],
      temperature = json['temperature'];

  @override
  String toString() => '{clouds: $clouds, day: $day, dayName: $dayName, temperature: $temperature}';

}

class Slope {
  final String id;
  final String address;
  final String city;
  final int conditionEqual;
  final int conditionMax;
  final int conditionMin;
  final String name;
  final int snowFall;
  final String status;
  final String updateTime;
  final List<Weather> weatherList;

  Slope.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['_id'],
        city = json['city'],
        address = json['address'],
        conditionEqual = json['condition_equal'],
        conditionMin = json['condition_min'],
        conditionMax = json['condition_max'],
        updateTime = json['update_time'],
        status = json['status'],
        snowFall = json['snow_fall'],
        weatherList = (json['weather'] as List).map( (e) => Weather.fromJson(e)).toList();

  @override
  String toString() => '{ _id: $id, name: $name, address: $address, city: $city, conditionMin: $conditionMin, conditionMax: $conditionMax, conditionEqual: $conditionEqual,'
      'snowFall: $snowFall, status: $status, updateTime: $updateTime, weatherList: $weatherList}';
}