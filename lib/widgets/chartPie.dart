import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math' as math;

class ChartPieWidget extends StatefulWidget {
  final Map<String, double> dataMap;
  const ChartPieWidget({Key? key, required this.dataMap}) : super(key: key);

  @override
  _ChartPieWidgetState createState() => _ChartPieWidgetState();
}

class _ChartPieWidgetState extends State<ChartPieWidget> {
  final colorList = <Color>[
    const Color.fromRGBO(244, 67, 54, 1),
    const Color.fromRGBO(255, 235, 59, 1),
    const Color(0xffe17055),
    const Color.fromRGBO(33, 150, 243, 1),
    const Color(0xfffdcb6e),
    const Color(0xfffd79a8),
    const Color(0xff6c5ce7),
    const Color.fromRGBO(76, 175, 80, 1),
    const Color(0xff00b894),
    const Color(0xffd63031),
    const Color(0xffe84393),
    const Color(0xff2d3436),
    const Color(0xff6d4c41),
    const Color(0xff2e7d32),
    const Color(0xff283593),
    const Color(0xffad1457),
    const Color(0xff00695c),
    const Color(0xff3e2723),
  ];
  //Ver valores por fuera
  final bool _showChartValuesOutside = true;
  //Grosor de ring
  final double _ringStrokeWidth = 50;
  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: widget.dataMap,
      chartLegendSpacing: 40,
      chartRadius: math.min(MediaQuery.of(context).size.width / 1.5, 300),
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      centerWidget: const Text(
        'Ventas',
        style: TextStyle(color: Colors.white),
      ),
      legendOptions: const LegendOptions(
        showLegendsInRow: true,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValuesInPercentage: true,
        showChartValuesOutside: _showChartValuesOutside,
      ),
      ringStrokeWidth: _ringStrokeWidth,
      colorList: colorList,
      baseChartColor: Colors.transparent,
    );
  }
}
