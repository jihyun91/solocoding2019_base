import 'package:flutter/material.dart';

class WeatherDetailPage extends StatefulWidget {
  WeatherDetailPage();

  @override
  _WeatherDetailPageState createState() => new _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  double weatherImageSize = 150.0;
  String imageUrl;

  Widget get weatherImage {
    return new Hero(
      tag:'hero',
      child: new Container(
        height: weatherImageSize,
        width: weatherImageSize,
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
            image: AssetImage('graphics/weather.jpg'),
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
          new Text(
            '서울',
            style: new TextStyle(fontSize: 32.0),
          ),
          new Text(
            '맑음',
            style: new TextStyle(fontSize: 20.0),
          ),
          new Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: new Text('위도 : 1111, 경도 : 22222'),
          )
        ],
      ),
    );
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