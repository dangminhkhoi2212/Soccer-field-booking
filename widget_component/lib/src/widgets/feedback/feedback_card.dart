import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:widget_component/my_library.dart';

class FeedbackCard extends StatefulWidget {
  final FeedbackItemModel feedback;

  const FeedbackCard({required this.feedback, Key? key}) : super(key: key);

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  late FeedbackItemModel _feedback;

  @override
  void initState() {
    super.initState();
    _feedback = widget.feedback;
  }

  Widget _buildName() {
    return Text(
      _feedback.user!.name!,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildStar() {
    return RatingBar.builder(
      initialRating: _feedback.star!.toDouble(),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      tapOnlyMode: true,
      itemCount: 5,
      itemPadding: EdgeInsets.zero,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemSize: 20,
      onRatingUpdate: (rating) {},
    );
  }

  Widget _buildImages() {
    final List<String> images = _feedback.images!;
    if (images.isEmpty) return const SizedBox();

    return GalleryImage(
      imageUrls: images,
      imageRadius: 12,
      closeWhenSwipeDown: true,
      closeWhenSwipeUp: true,
      maxScale: 5,
      numOfShowImages: min(_feedback.images!.length, 3),
      loadingWidget: MyLoading.spinkit(),
    );
  }

  Widget _buildContent() {
    return Text(_feedback.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildName(),
        const SizedBox(
          height: 5,
        ),
        _buildStar(),
        const SizedBox(
          height: 5,
        ),
        Flexible(child: _buildImages()),
        const SizedBox(
          height: 5,
        ),
        _buildContent(),
      ],
    );
  }
}
