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
  String date;

  Weather({this.id, this.main, this.description, this.icon, this.date});
}

class Forecast {
  final List<dynamic> list;

  Forecast({this.list});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
        list: json['list']
    );
  }
}