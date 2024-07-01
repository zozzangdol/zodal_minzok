import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:collection/collection.dart';
import 'package:zodal_minzok/rating/model/rating_model.dart';

// @author zosu
// @since 2024-06-24
// @comment Detail Page 하단의 후기 카드

class RatingCard extends StatelessWidget {
  const RatingCard({required this.avatarImage,
    required this.images,
    required this.email,
    required this.rating,
    required this.content,
    super.key});

  factory RatingCard.fromModel({
    required RatingModel model
}) {
    return RatingCard(
        avatarImage: NetworkImage(
          model.user.imageUrl
        ),
        images: model.imgUrls.map((e) => Image.network(e)).toList(),
        email: model.user.username,
        rating: model.rating,
        content: model.content);
  }

  // ImageProvider like networkImage, assetImage...
  final ImageProvider avatarImage;

  // 리뷰 사진
  final List<Image> images;

  // 이메일
  final String email;

  // 별점
  final int rating;

  // 리뷰
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _Header(
            avatarImage: avatarImage,
            email: email,
            rating: rating,
          ),
          SizedBox(
            height: 8.0,
          ),
          _Body(
            content: '맛있어요',
          ),
          SizedBox(height: 8.0,),
          if(images.length > 0)
          SizedBox(
              height : 100, child: _Images(images: images,),),
        ],
      ),
    );
  }
}

// Header
class _Header extends StatelessWidget {
  final ImageProvider avatarImage;

  // 이메일
  final String email;

  // 별점
  final int rating;

  const _Header({required this.avatarImage,
    required this.email,
    required this.rating,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: avatarImage,
          radius: 12.0,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
            5,
                (index) =>
                Icon(
                  index < rating ? Icons.star : Icons.star_border_outlined,
                  color: PRIMARY_COLOR,
                ))
      ],
    );
  }
}

// Body
class _Body extends StatelessWidget {
  final String content;

  const _Body({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

// Image
class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed((index, element) =>
          Padding(padding: EdgeInsets.only(
            right: index == images.length - 1 ? 0 : 16.0,), child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0,),
            child: element,
          ),),)
          .toList(),
    );
  }
}
