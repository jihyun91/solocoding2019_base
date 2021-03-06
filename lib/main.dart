import 'package:flutter/material.dart';
import 'package:solocoding2019_base/widgets/main/view_weather.dart';

void main() => runApp(MyApp());

// This widget is the root of your application.
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // set material design app
    return MaterialApp(
      title: 'Weather App', // application name
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Weather App'), // app bar title
        ),
        body: Center(
          child: WeatherDetailPage(), // center text
        ),
      ),
    );
  }
}
