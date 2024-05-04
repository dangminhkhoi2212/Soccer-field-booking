import 'package:client_app/config/api_config.dart';
import 'package:dio/dio.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _feedbackCardState = GlobalKey<_FeedbackPageState>();
  int _groupValue = 0;
  bool _isLoading = false;
  String? _fieldID;
  StatisticFeedbackModel? _statistic = StatisticFeedbackModel();
  final _logger = Logger();
  final ApiConfig apiConfig = ApiConfig();
  late FeedbackService _feedbackService;
  FeedbackModel _feedbackData = FeedbackModel();
  @override
  void initState() {
    super.initState();
    _fieldID = Get.parameters['fieldID'];
    _getValues();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    _feedbackService = FeedbackService(apiConfig.dio);
    super.setState(fn);
  }

  Future _getFeedbacks(
      {int page = 1, int? star, int limit = 30, String? sortBy}) async {
    if (_fieldID == null) return;
    try {
      final Response response = await _feedbackService.getFeedbacks(
          fieldID: _fieldID!,
          limit: limit,
          page: page,
          sortBy: sortBy,
          star: star);
      if (response.statusCode == 200) {
        final data = response.data;
        _feedbackData = FeedbackModel.fromJson(data);
      } else {
        throw response.data;
      }
    } catch (e) {
      _logger.e(e, error: '_getFeedbacks');
    }
  }

  Future _getStatisticFeedback() async {
    try {
      Response? response =
          await _feedbackService.getStatisticFeedback(fieldID: _fieldID);
      if (response.statusCode == 200) {
        final data = response.data;
        _statistic = StatisticFeedbackModel.fromJson(data);
      }
    } catch (e) {
      _logger.e(e, error: '_getStatisticFeedback');
    }
  }

  Future _getValues() async {
    setState(() {
      _isLoading = true;
    });
    await Future.wait([_getFeedbacks(), _getStatisticFeedback()]);
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildFeedbacks() {
    final List<FeedbackItemModel> feedbackList = _feedbackData.feedbacks ?? [];

    if (feedbackList.isEmpty) {
      return EmptyWidget(
        packageImage: PackageImage.Image_2,
        title: 'Feedback is empty',
        hideBackgroundAnimation: true,
      );
    }
    return Expanded(
      child: _isLoading
          ? Center(
              child: MyLoading.spinkit(),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: ScreenUtil.getWidth(context),
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final fb = feedbackList[index];
                    return FeedbackCard(feedback: fb);
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(thickness: .4),
                  itemCount: feedbackList.length),
            ),
    );
  }

  Widget _buildStar(int star, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Wrap(
        spacing: 3,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: [
          Text(star.toString()),
          RatingBar.builder(
            initialRating: 1,
            minRating: 1,
            direction: Axis.horizontal,
            ignoreGestures: true,
            itemCount: 1,
            itemPadding: EdgeInsets.zero,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemSize: 20,
            onRatingUpdate: (rating) {},
          ),
          Text('(${total.toString()})'),
        ],
      ),
    );
  }

  Future _handleChoice(int? value) async {
    setState(() {
      _isLoading = true;
    });
    _groupValue = value!;

    if (_groupValue == 0) {
      await _getFeedbacks();
    } else if (_groupValue == 6) {
      await _getFeedbacks(sortBy: 'newest');
    } else {
      await _getFeedbacks(star: _groupValue);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildButtonChoice() {
    final tabs = {
      0: Text('All (${_statistic!.totalFeedback ?? 0})'),
      6: const Text('Newest'),
      5: _buildStar(5, _statistic!.fiveStar ?? 0),
      4: _buildStar(4, _statistic!.fourStar ?? 0),
      3: _buildStar(3, _statistic!.threeStar ?? 0),
      2: _buildStar(2, _statistic!.twoStar ?? 0),
      1: _buildStar(1, _statistic!.oneStar ?? 0),
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: CupertinoSlidingSegmentedControl(
        children: tabs,
        groupValue: _groupValue,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        thumbColor: MyColor.secondary,
        onValueChanged: (int? value) => _handleChoice(value!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Feedback')),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [_buildButtonChoice(), _buildFeedbacks()],
        ),
      ),
    );
  }
}
