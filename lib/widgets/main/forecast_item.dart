import 'package:flutter/material.dart';
import  '../../models/weather_model.dart';

class ForecastItem extends StatefulWidget {
  final Weather weather;

  ForecastItem(this.weather);

  @override
  ForecastItemState createState() {
    return new ForecastItemState();
  }
}

class ForecastItemState extends State<ForecastItem> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Center(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: new Text('일자 : ${widget.weather.icon}'),
              ),
              new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: new Text('날씨 : ${widget.weather.icon}'),
              )
            ],
          ),
        ),
        new Divider()
      ]
      );
  }
}
