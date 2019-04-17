import 'package:flutter/material.dart';
import 'package:solocoding2019_base/widgets/main/forecast_item.dart';
import  '../../models/weather_model.dart';

class ForecastList extends StatelessWidget {
  final List<Weather> weathers;

  ForecastList({this.weathers});

  ListView _buildList(context) {
    return new ListView.builder(
      itemCount: weathers.length,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context, int) {
        return new ForecastItem(weathers[int]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }
}
