import 'dart:math';

import 'package:empty_widget/empty_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ksport_seller/pages/home/widget/filter_chart.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';
import 'package:intl/intl.dart';

class MyLineChart extends StatefulWidget {
  final StatisticRevenueModel statisticRevenue;
  const MyLineChart({super.key, required this.statisticRevenue});

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  final Color _mainColor = const Color.fromARGB(255, 123, 220, 126);
  bool _isGrid = false;
  bool _isBorder = false;
  final _logger = Logger();
  StatisticRevenueModel _statisticRevenue = StatisticRevenueModel();

  final List<FlSpot> _data = [FlSpot.zero];
  List<Color> gradientColors = [
    const Color.fromARGB(255, 176, 234, 160),
    const Color.fromARGB(255, 49, 226, 167),
  ];
  double minY = 0;
  double minX = 1;
  double maxY = 100;
  double maxX = 12;
  bool showAvg = false;
  @override
  void initState() {
    super.initState();
    _statisticRevenue = widget.statisticRevenue;
    _handelData();
  }

  @override
  void didUpdateWidget(covariant MyLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statisticRevenue != oldWidget.statisticRevenue) {
      setState(() {
        _statisticRevenue = widget.statisticRevenue;
      });
      _handelData();
    }
  }

  _buildOptionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          activeColor: MyColor.primary,
          value: _isGrid,
          onChanged: (value) {
            setState(
              () {
                _isGrid = value!;
              },
            );
          },
        ),
        const Text('Grid'),
        const SizedBox(width: 20),
        Checkbox(
          activeColor: MyColor.primary,
          value: _isBorder,
          onChanged: (value) {
            setState(
              () {
                _isBorder = value!;
              },
            );
          },
        ),
        const Text('Border'),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    // _logger.d(value);

    String text;
    switch (value.toInt()) {
      case 1:
        text = '0.1K';
        break;
      case 1000:
        text = '1k';
        break;
      case 2000:
        text = '2k';
        break;
      case 3000:
        text = '3k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  void _handelData() {
    final values = _statisticRevenue.values;

    if (values == null || values.isEmpty) {
      return;
    } else {
      _data.clear();
      for (var i = 0; i < values.length; i++) {
        final revenue = values[i].revenue;
        final id = values[i].id;
        if (revenue != null) {
          _data.add(FlSpot(id!.toDouble(), revenue.toDouble()));
          maxX = max(maxX, id.toDouble());
          minX = min(minX, id.toDouble());
          maxY = max(maxY, revenue.toDouble());
          // minY = min(minY, revenue.toDouble());
        }
      }
    }
    if (values.length < 2) {
      _data.insert(0, FlSpot.zero);
    }
    // _logger.d(error: maxX, 'maxX');
    // _logger.d(error: maxY, 'maxY');
    // _logger.d(error: _data, 'data');

    setState(() {});
  }

  Widget axisNameWidget() {
    String str;
    if (_statisticRevenue.typeID != null) {
      str =
          '${_statisticRevenue.typeID![0].toUpperCase()}${_statisticRevenue.typeID!.substring(1)}';
    } else {
      str = '';
    }
    return Text(
      str,
      style: const TextStyle(fontSize: 10),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: _isGrid,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: _mainColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: _mainColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: axisNameWidget(),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                )),
          ),
        ),
        leftTitles: AxisTitles(
          axisNameSize: 20,

          axisNameWidget: const Text(
            'Revenue',
            style: TextStyle(fontSize: 10),
          ),

          // axisNameSize: 10,
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  NumberFormat.compactCurrency(
                    locale: "en-US",
                    symbol: '',
                  ).format(value),
                  style: const TextStyle(fontSize: 10),
                )),
          ),
        ),
      ),
      borderData: FlBorderData(
        show: _isBorder,
        border: Border.all(
            color: const Color(0xff37434d),
            strokeAlign: BorderSide.strokeAlignCenter),
      ),
      // minX: minX,
      // maxX: maxX,
      // minY: minY,
      // maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: _data,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: <Widget>[
          _buildOptionButton(),
          const FilterChart(),
          const SizedBox(
            height: 10,
          ),
          const Text('Revenue statistics chart'),
          const SizedBox(height: 5),
          Container(
              padding: const EdgeInsets.all(10),
              width: ScreenUtil.getWidth(context),
              height: 350,
              child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final values = _statisticRevenue.values;

    if (values != null && values.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: LineChart(
          mainData(),
        ),
      );
    }
    return EmptyWidget(
      hideBackgroundAnimation: true,
      packageImage: PackageImage.Image_2,
      title: 'No data',
    );
  }
}
