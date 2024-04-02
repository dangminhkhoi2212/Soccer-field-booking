import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ksport_seller/pages/home/widget/header.dart';
import 'package:ksport_seller/pages/home/widget/my_line_chart.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StatisticService _statisticService = StatisticService();
  final _box = GetStorage();
  final _logger = Logger();
  StatisticRevenueModel _statisticRevenue = StatisticRevenueModel();
  String? _sellerID;
  bool _isLoading = false;

  Function? _listenDate;
  Function? _listenMonth;
  Function? _listenYear;
  @override
  void initState() {
    super.initState();
    _sellerID = _box.read('id');
    _listenParmas();
    _getStatisticRevenue(
        sellerID: _sellerID!,
        date: FormatUtil.formatDate(DateTime(2024, 3, 29)));
  }

  void _listenParmas() {
    _listenDate = _box.listenKey(
      'date',
      (value) {
        _logger.d(value);
        _getStatisticRevenue(sellerID: _sellerID!, date: value);
      },
    );
    _listenMonth = _box.listenKey(
      'month',
      (value) {
        _getStatisticRevenue(sellerID: _sellerID!, month: value);
      },
    );
    _listenDate = _box.listenKey(
      'year',
      (value) {
        _getStatisticRevenue(sellerID: _sellerID!, year: value);
      },
    );
  }

  void _disposeListenParams() {
    try {
      _listenDate!.call();
      _listenMonth!.call();
      _listenYear!.call();
    } catch (e) {
      _logger.e(error: e, '_disposeListenParams');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _disposeListenParams();
  }

  Future _getStatisticRevenue(
      {required String sellerID,
      String? date,
      String? month,
      String? year}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Response? response = await _statisticService.getStatisticRevenue(
          sellerID: _sellerID!, date: date, month: month, year: year);
      if (response!.statusCode == 200) {
        _statisticRevenue = StatisticRevenueModel.fromJson(response.data);
        _logger.d(response.data, error: 'getStatisticRevenue');
      }
    } catch (e) {
      _logger.e(e, error: '_getStatisticRevenue');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const HeaderHome(),
            const SizedBox(
              height: 10,
            ),
            MyLineChart(statisticRevenue: _statisticRevenue),
          ],
        ),
      ),
    );
  }
}
