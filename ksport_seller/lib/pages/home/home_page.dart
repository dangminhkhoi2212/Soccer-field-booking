import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:ksport_seller/config/api_config.dart';
import 'package:ksport_seller/pages/home/widget/header.dart';
import 'package:ksport_seller/pages/home/widget/my_line_chart.dart';
import 'package:ksport_seller/pages/home/widget/home_page_state.dart';
import 'package:ksport_seller/pages/home/widget/statistic_card.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeController = Get.put(HomeController());
  final StatisticService _statisticService = StatisticService(ApiConfig().dio);
  final _box = GetStorage();
  final _logger = Logger();
  StatisticRevenueModel _statisticRevenue = StatisticRevenueModel();
  String? _sellerID;
  TotalFieldsModel? _totalFields;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sellerID = _box.read('id');

    // _getStatisticRevenue(
    //     sellerID: _sellerID!, year: _homeController.year.value);
    _initApi();
    ever(_homeController.year, (value) {
      if (value != '') {
        _getStatisticRevenue(sellerID: _sellerID!, year: value);
      }
    });
    ever(_homeController.month, (value) {
      if (value != '') {
        _getStatisticRevenue(sellerID: _sellerID!, month: value);
      }
    });
    ever(_homeController.date, (value) {
      if (value != '') {
        _getStatisticRevenue(sellerID: _sellerID!, date: value);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    Get.delete<HomeController>(force: true);
  }

  Future _getTotalFields({
    required String sellerID,
  }) async {
    if (_sellerID == null) return;
    try {
      final Response response =
          await _statisticService.getTotalFields(userID: _sellerID!);
      if (response.statusCode == 200) {
        _totalFields = TotalFieldsModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
                titleDebug: '_getTotalFields',
                messageDebug: e.response!.data ?? e)
            .showErrorDialog(context);
      }
    } catch (e) {
      _logger.e(e, error: '_getTotalFields');
    }
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
      final Response response = await _statisticService.getStatisticRevenue(
          sellerID: _sellerID!, date: date, month: month, year: year);
      if (response.statusCode == 200) {
        _statisticRevenue = StatisticRevenueModel.fromJson(response.data);
        _logger.d(response.data, error: 'getStatisticRevenue');
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
                titleDebug: 'getStatisticRevenue',
                messageDebug: e.response!.data ?? e)
            .showErrorDialog(context);
      }
    } catch (e) {
      _logger.e(e, error: '_getStatisticRevenue');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future _initApi() async {
    setState(() {
      _isLoading = true;
    });
    await Future.wait([
      _getTotalFields(sellerID: _sellerID!),
      _getStatisticRevenue(
          sellerID: _sellerID!, year: _homeController.year.value)
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const HeaderHome(),
              const SizedBox(
                height: 10,
              ),
              StatisticCard(totalFields: _totalFields),
              const SizedBox(
                height: 10,
              ),
              MyLineChart(
                  statisticRevenue: StatisticRevenueModel.fromJson(
                      _statisticRevenue.toJson())),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalFieldsModel {
  int? totalRevenue;
  int? totalFollow;
  int? totalField;
  int? totalOrder;

  TotalFieldsModel(
      {this.totalRevenue, this.totalFollow, this.totalField, this.totalOrder});

  TotalFieldsModel.fromJson(Map<String, dynamic> json) {
    totalRevenue = json['totalRevenue'];
    totalFollow = json['totalFollow'];
    totalField = json['totalField'];
    totalOrder = json['totalOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalRevenue'] = totalRevenue;
    data['totalFollow'] = totalFollow;
    data['totalField'] = totalField;
    data['totalOrder'] = totalOrder;
    return data;
  }
}
