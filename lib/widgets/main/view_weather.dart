import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherDetailPage extends StatefulWidget {
  Geolocator geolocator = Geolocator();
  Position userLocation;
  Post postResult;
  List<dynamic> curWeather;
  String curLocale;
  double weatherImageSize = 150.0;
  String imageUrl;
  AssetImage img = AssetImage('graphics/weather.jpg');

  @override
  _WeatherDetailPageState createState() => new _WeatherDetailPageState();
}

// Model: Post
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class Weather {
  int id;
  String main;
  String description;
  String icon;
}

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

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getLocation().then((position) {
      setState(() {
        widget.userLocation = position;
      });

      fetchWeather(position).then((json) {
        setState(() {
          widget.curWeather = json.weather;
          widget.curLocale = json.name;
          print(widget.curWeather[0]['main']);
          print(widget.curLocale);
        });
      });
    });

    setState(() {
//        widget.img = AssetImage('graphics/sunny.jpg');
    });
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

  // Service: fetchPost
  Future<WeatherInfo> fetchWeather(Position position) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat='+position.latitude.toString()+'&lon='+position.longitude.toString()+'&appid=9201513ac5885bdafe715190e9234aaf';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return WeatherInfo.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load post');
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