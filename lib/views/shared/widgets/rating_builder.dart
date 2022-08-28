import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:printore/controller/review_controller.dart';
import 'package:printore/views/shared/styles/colors.dart';

class RatingBuilder extends StatefulWidget {
  final double? itemSize;
  final double rating;

  const RatingBuilder({
    Key? key,
    required this.rating,
    required this.itemSize,
  }) : super(key: key);

  @override
  State<RatingBuilder> createState() => _RatingBuilderState();
}

class _RatingBuilderState extends State<RatingBuilder> {
  late ReviewController _ratingController;
  @override
  Widget build(BuildContext context) {
    _ratingController = Get.find<ReviewController>();
    return Center(
      child: RatingBar.builder(
          allowHalfRating: true,
          initialRating: widget.rating,
          itemSize: widget.itemSize!,
          updateOnDrag: false,
          minRating: 1,
          direction: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, _) => Icon(
                Icons.star,
                color: MainColor.yellowColor,
              ),
          onRatingUpdate: (rating) {
            setState(() {
              _ratingController.updateNewRating(rating);
            });
          }),
    );
  }
}
