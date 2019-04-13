import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherDetailPage extends StatefulWidget {
  Geolocator geolocator = Geolocator();
  Position userLocation;
  Post postResult;
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

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getLocation().then((position) {
      fetchPost().then((json) {
        setState(() {
          widget.postResult = json;
        });
      });
      setState(() {
        widget.userLocation = position;
      });
      setState(() {
//        widget.img = AssetImage('graphics/sunny.jpg');
      });
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
            child: widget.postResult == null ? new Text('') : new Text('위도 :' + widget.postResult.body + '경도 : 22222'),
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
  Future<Post> fetchPost() async {
    final url = 'https://jsonplaceholder.typicode.com/posts/1';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Post.fromJson(jsonBody);
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