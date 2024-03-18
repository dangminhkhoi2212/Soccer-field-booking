import 'package:client_app/pages/field_booking/widget/feedback_card.dart';
import 'package:dio/dio.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FeedbackField extends StatefulWidget {
  final String fieldID;
  const FeedbackField({super.key, required this.fieldID});

  @override
  State<FeedbackField> createState() => _FieldInfoState();
}

class _FieldInfoState extends State<FeedbackField> {
  int _groupValue = 0;
  bool _isLoading = false;
  late String _fieldID;
  final _logger = Logger();
  FeedbackModel? _feedback = FeedbackModel.fromJson({});
  final FeedbackService _feedbackService = FeedbackService();

  final PagingController _pagingController = PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    _fieldID = widget.fieldID;
    _getFeedbacks();
  }

  void _showOptionStar() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            decoration: const BoxDecoration(color: Colors.white),
            width: double.infinity,
            child: GiffyBottomSheet(
              giffy: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select a star to view'),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal, tapOnlyMode: true,
                    allowHalfRating: false,
                    itemCount: 5.toInt(),
                    // itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 12,
                    ),
                    onRatingUpdate: (value) {
                      print(value.toString());
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future _getFeedbacks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Response? response =
          await _feedbackService.getFeedbacks(fieldID: _fieldID);
      if (response!.statusCode == 200) {
        final data = response.data;
        _feedback = FeedbackModel.fromJson(data);
        _logger.d(_feedback!.feedbacks.toString(), error: '_getFeedbacks');
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

  Future _handleButtonChoice(int value) async {
    try {
      setState(() {
        _groupValue = value ?? 0;
      });
    } catch (e) {}
  }

  Widget _buildButtonChoice() {
    final tabs = {
      0: const Text('All'),
      1: const Text('Newest'),
      2: const Text('Star'),
    };
    return SizedBox(
      width: double.infinity,
      child: CupertinoSlidingSegmentedControl(
        children: tabs,
        groupValue: _groupValue,
        thumbColor: MyColor.primary,
        onValueChanged: (value) {
          _handleButtonChoice(value!);
        },
      ),
    );
  }

  Widget _buildElevatedButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  Widget _buildStarButton() {
    return ElevatedButton(
      onPressed: () {
        _showOptionStar();
      },
      child: const Text('Star'),
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
    return SizedBox(
      height: 400,
      width: ScreenUtil.getWidth(context),
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final fb = feedbackList[index];
            return FeedbackCard(feedback: fb);
          },
          separatorBuilder: (context, index) => const Divider(thickness: .4),
          itemCount: feedbackList.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feedback',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            _buildButtonChoice(),
            _buildFeedbacks()
          ],
        ),
      ),
    );
  }
}
