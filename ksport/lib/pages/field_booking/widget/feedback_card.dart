import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:widget_component/my_library.dart';

class FeedbackCard extends StatefulWidget {
  final FeedbackItemModel feedback;
  const FeedbackCard({super.key, required this.feedback});

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  FeedbackItemModel? _feedback;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _feedback = widget.feedback;
  }

  Widget _buildName() {
    return Text(
      _feedback!.userID!.name! ?? '',
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildStar() {
    return RatingBar.builder(
      initialRating: _feedback!.star!.toDouble(),
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

  @override
  Widget _buildImages() {
    final List<String?> images = _feedback!.images!;
    if (images.isEmpty) return const SizedBox();
    return Wrap(
        direction: Axis.horizontal,
        spacing: 10,
        children: images.map((String? imageUrl) {
          return MyImage(
            width: 80,
            height: 80,
            src: imageUrl ?? '',
            radius: 12,
          );
        }).toList());
  }

  Widget _buildContent() {
    return Text(_feedback!.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      direction: Axis.vertical,
      spacing: 10,
      children: [_buildName(), _buildStar(), _buildImages(), _buildContent()],
    );
  }
}
