class WeatherInfo {
  final List<dynamic> weather;
  final String name;

  WeatherInfo({this.weather, this.name});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
        weather: json['weather'],
        name: json['name']
    );
  }
}

class Weather {
  int id;
  String main;
  String description;
  String icon;

  Weather({this.id, this.main, this.description, this.icon});
}