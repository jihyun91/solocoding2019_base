import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:solocoding2019_base/widgets/main/forecast_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import  '../../models/weather_model.dart';

class WeatherDetailPage extends StatefulWidget {
  Geolocator geolocator = Geolocator();
  Position userLocation;
  List<dynamic> curWeather;
  var weathers = <Weather>[]
    ..add(new Weather(main: '', date: ''));
  String curLocale;
  double weatherImageSize = 150.0;
  String imageUrl;
  String latelySearchLoc = '';
  AssetImage img = AssetImage('graphics/weather.jpg');

  @override
  _WeatherDetailPageState createState() => new _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  final String _kLatelySearchLocPref = "latelySearchLoc";

  @override
  void initState() {
    super.initState();
    _fetchCurLocationAndWeather(true);
  }

  Widget get weatherImage {
    return new Hero(
      tag:'hero',
      child: new Container(
        height: widget.weatherImageSize,
        width: widget.weatherImageSize,
        constraints: new BoxConstraints(),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            const BoxShadow(
                offset: const Offset(1.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: -1.0,
                color: const Color(0x33000000)),
            const BoxShadow(
                offset: const Offset(2.0, 1.0),
                blurRadius: 3.0,
                spreadRadius: 0.0,
                color: const Color(0x24000000)),
            const BoxShadow(
                offset: const Offset(3.0, 1.0),
                blurRadius: 4.0,
                spreadRadius: 2.0,
                color: const Color(0x1F000000)),
          ],
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: widget.img,
          ),
        ),
      ),
    );
  }

  Widget get selectedLocaleBtns {
    return new FittedBox(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(onPressed: () => _onClickCityBtn("Seoul"), child: Text('Seoul'), color: Colors.lightBlueAccent),
              RaisedButton(onPressed: () => _onClickCityBtn("Daejeon"), child: Text('Daejeon'), color: Colors.lightBlueAccent),
              RaisedButton(onPressed: () => _onClickCityBtn("Busan"), child: Text('Busan'), color: Colors.lightBlueAccent),
              RaisedButton(onPressed: _onClickCurLocaleBtn, child: Text('Cur Locale'), color: Colors.lightBlueAccent),
            ]
        )
    );
  }

  Widget get weatherView {
    return new Container(
      padding: new EdgeInsets.symmetric(vertical: 32.0),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.yellow[800],
            Colors.yellow[700],
            Colors.yellow[600],
            Colors.yellow[400],
          ],
        ),
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          selectedLocaleBtns,
          weatherImage,
          widget.curLocale == null ? new Text('위치정보 셋팅 중') :
          new Text(
            widget.curLocale,
            style: new TextStyle(fontSize: 32.0),
          ),
          widget.curWeather == null ? new Text('날씨 정보 셋팅 중') :
          new Text(
            widget.curWeather[0]['main'],
            style: new TextStyle(fontSize: 20.0),
          ),
          new Text(
            '최근 검색 지역 : ${widget.latelySearchLoc}',
            style: new TextStyle(fontSize: 15.0),
          ),
          new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: widget.userLocation == null ? new Text('위도경도 정보 셋팅 중') : new Text('위도 : ' + widget.userLocation.latitude.toString() + ' 경도 : ' + widget.userLocation.longitude.toString()),
          ),
          widget.latelySearchLoc == null ? new Text('최근 검색 지역 셋팅 중') :
          new Divider(),
          new Text(
            '최근 4일 시간 별 예보',
            style: new TextStyle(fontSize: 18.0, color : Colors.deepOrange),
          ),
          new Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 300,
            child: new Scrollbar(
              child : new ForecastList(weathers: widget.weathers)
            )
          ),
        ],
      ),
    );
  }

  void _onClickCityBtn(String city) async {
    double latitude;
    double longitude;

    switch (city) {
      case "Seoul": {
        latitude = 37.56;
        longitude = 126.97;
      }
      break;

      case "Daejeon" : {
        latitude = 36.35;
        longitude = 127.38;
      }
      break;

      case "Busan" : {
        latitude = 35.17;
        longitude = 129.07;
      }
      break;
    }

    _setLatelySearchLocAndSetState(city);

    Position position = new Position(latitude: latitude, longitude: longitude);

    _fetchWeather(latitude.toString(), longitude.toString()).then((json) {
      setState(() {
        widget.userLocation = position;
        widget.curWeather = json.weather;
        widget.curLocale = json.name;
        widget.img = _getWeatherImg(json.weather[0]['main']);

        _getForecast(position.latitude.toString(), position.longitude.toString()).then((onValue) {
          setState(() {
            widget.weathers = onValue;
          });
        });
      });
    });
  }

  void _onClickCurLocaleBtn() async {
    _fetchCurLocationAndWeather(false);
  }

  void _fetchCurLocationAndWeather(bool isInit) {
    _getLocation().then((position) {
      setState(() {
        widget.userLocation = position;
      });

      _fetchWeather(position.latitude.toString(), position.longitude.toString()).then((json) {
        setState(() {
          widget.curWeather = json.weather;
          widget.curLocale = json.name;
          widget.img = _getWeatherImg(json.weather[0]['main']);

          _getForecast(position.latitude.toString(), position.longitude.toString()).then((onValue) {
            setState(() {
              widget.weathers = onValue;
            });
          });

          if (!isInit) {
            _setLatelySearchLocAndSetState(json.name);
          }
        });
      });
    });

    _getLatelySearchLocPref().then((onValue) {
      setState(() {
        widget.latelySearchLoc = onValue;
      });
    });
  }

  void _setLatelySearchLocAndSetState(String city) async {
    _setLatelySearchLocPref(city).then((onValue) {
      if (onValue) {
        _getLatelySearchLocPref().then((onValue) {
          setState(() {
            widget.latelySearchLoc = onValue;
          });
        });
      }
    });
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await widget.geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future<WeatherInfo> _fetchWeather(String latitude, String longitude) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat='+latitude+'&lon='+longitude+'&appid=9201513ac5885bdafe715190e9234aaf';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return WeatherInfo.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<Forecast> _fetchForecast(String latitude, String longitude) async {
    final url = 'https://api.openweathermap.org/data/2.5/forecast/hourly?lat=$latitude&lon=$longitude&appid=9201513ac5885bdafe715190e9234aaf';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Forecast.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<List<Weather>> _getForecast(String latitude, String longitude) async {
    final forecast = await _fetchForecast(latitude, longitude);

    List<Weather> weatherList = forecast.list.map((data) {
      return new Weather(main : data['weather'][0]['main'], date: data['dt_txt']);
    }).toList();

    return weatherList;
  }

  AssetImage _getWeatherImg(String weather) {
    var path;

    switch (weather) {
      case "Clear": {
        path = 'graphics/sunny.jpg';
      }
      break;

      case "Clouds" : {
        path = 'graphics/cloud.png';
      }
      break;

      case "Snow" : {
        path = 'graphics/snow.png';
      }
      break;

      case "Rain" : {
        path = 'graphics/rain.png';
      }
      break;

      case "Drizzle" : {
        path = 'graphics/rain.png';
      }
      break;

      case "Thunderstorm" : {
        path = 'graphics/thunder.png';
      }
      break;

      default : {
        path = 'graphics/haze.png';
      }
      break;
    }

    return AssetImage(path);
  }

  Future<String> _getLatelySearchLocPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_kLatelySearchLocPref) ?? '';
  }

  Future<bool> _setLatelySearchLocPref(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_kLatelySearchLocPref, value);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: new ListView(
        children: <Widget>[weatherView],
      ),
    );
  }
}