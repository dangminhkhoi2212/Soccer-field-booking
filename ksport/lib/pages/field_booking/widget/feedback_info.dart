import 'dart:math';

import 'package:dio/dio.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FeedbackField extends StatefulWidget {
  final String fieldID;
  final StatisticFeedbackModel statistic;
  const FeedbackField(
      {super.key, required this.fieldID, required this.statistic});

  @override
  State<FeedbackField> createState() => _FieldInfoState();
}

class _FieldInfoState extends State<FeedbackField> {
  final int _groupValue = 0;
  bool _isLoading = false;
  late String _fieldID;
  final _logger = Logger();
  StatisticFeedbackModel _statistic = StatisticFeedbackModel();
  FeedbackModel? _feedback = FeedbackModel.fromJson({});
  final FeedbackService _feedbackService = FeedbackService();

  final PagingController _pagingController = PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    _fieldID = widget.fieldID;
    _statistic = widget.statistic;
    _getFeedbacks();
  }

  Future _getFeedbacks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Response? response =
          await _feedbackService.getFeedbacks(fieldID: _fieldID, limit: 5);
      if (response!.statusCode == 200) {
        final data = response.data;
        _feedback = FeedbackModel.fromJson(data);
      } else {
        throw response.data;
      }
    } catch (e) {
      _logger.e(e, error: '_getFeedbacks');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildStar() {
    return RatingBar.builder(
      initialRating: 5,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      tapOnlyMode: false,
      itemCount: 5,
      ignoreGestures: true,
      itemPadding: EdgeInsets.zero,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemSize: 20,
      onRatingUpdate: (rating) {},
    );
  }

  Widget _buildTitle() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutePaths.feedback, parameters: {'fieldID': _fieldID});
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: ScreenUtil.getWidth(context),
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 10,
            blurStyle: BlurStyle.outer,
            color: Colors.black12,
          ),
        ], borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              direction: Axis.vertical,
              spacing: 5,
              children: [
                const Text(
                  'Feedback',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Wrap(spacing: 10, children: [
                  _buildStar(),
                  Text('(${_statistic.totalFeedback ?? 0})')
                ]),
              ],
            ),
            const SizedBox(
              height: 35,
              child: LineIcon.angleRight(
                size: 18,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbacks() {
    final List<FeedbackItemModel> feedbackList = _feedback?.feedbacks ?? [];

    if (feedbackList.isEmpty) {
      return EmptyWidget(
        packageImage: PackageImage.Image_2,
        title: 'Feedback is empty',
        hideBackgroundAnimation: true,
      );
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final fb = feedbackList[index];
            return FeedbackCard(feedback: fb);
          },
          separatorBuilder: (context, index) => const Divider(thickness: .4),
          itemCount: min(feedbackList.length, 5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          const SizedBox(
            height: 10,
          ),
          Flexible(child: _buildFeedbacks())
        ],
      ),
    );
  }
}
