import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import  '../../models/weather_model.dart';

class WeatherDetailPage extends StatefulWidget {
  Geolocator geolocator = Geolocator();
  Position userLocation;
  List<dynamic> curWeather;
  String curLocale;
  double weatherImageSize = 150.0;
  String imageUrl;
  AssetImage img = AssetImage('graphics/weather.jpg');

  @override
  _WeatherDetailPageState createState() => new _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  @override
  void initState() {
    super.initState();
    _fetchCurLocationAndWeather();
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
              RaisedButton(onPressed: _onClickSeoulBtn, child: Text('Seoul'), color: Colors.lightBlueAccent),
              RaisedButton(onPressed: _onClickSeoulBtn, child: Text('Seoul'), color: Colors.lightBlueAccent),
              RaisedButton(onPressed: _onClickSeoulBtn, child: Text('Seoul'), color: Colors.lightBlueAccent),
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
          new Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: widget.userLocation == null ? new Text('위도경도 정보 셋팅 중') : new Text('위도 : ' + widget.userLocation.latitude.toString() + ' 경도 : ' + widget.userLocation.longitude.toString()),
          )
        ],
      ),
    );
  }

  void _onClickSeoulBtn() async {
    double longitude = 121.0;
    double latitude = 32.0;

    Position position = new Position(latitude: latitude, longitude: longitude);

    _fetchWeather(latitude.toString(), longitude.toString()).then((json) {
      setState(() {
        widget.userLocation = position;
        widget.curWeather = json.weather;
        widget.curLocale = json.name;
      });
    });
  }

  void _onClickCurLocaleBtn() async {
    _fetchCurLocationAndWeather();
  }

  void _fetchCurLocationAndWeather() {
    _getLocation().then((position) {
      setState(() {
        widget.userLocation = position;
      });

      _fetchWeather(position.latitude.toString(), position.longitude.toString()).then((json) {
        setState(() {
          widget.curWeather = json.weather;
          widget.curLocale = json.name;
        });
        setState(() {
//        widget.img = AssetImage('graphics/sunny.jpg');
        });
      });
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