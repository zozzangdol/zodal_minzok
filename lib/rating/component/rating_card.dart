import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zodal_minzok/common/const/data.dart';

// @author zosu
// @since 2024-06-24
// @comment Detail Page 하단의 후기 카드

class RatingCard extends StatelessWidget {
  const RatingCard(
      {required this.avatarImage,
      required this.images,
      required this.email,
      required this.rating,
      required this.content,
      super.key});

  // ImageProvider like networkImage, assetImage...
  final ImageProvider avatarImage;

  // 리뷰 사진
  final List<String> images;

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
          _Header(avatarImage: avatarImage, email: email, rating: rating,),
          _Body(),
          _Images(),
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

  const _Header(
      {required this.avatarImage,
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
        ...List.generate(5, (index) => Icon( index < rating ? Icons.star: Icons.star_border_outlined, color: PRIMARY_COLOR,))
      ],
    );
  }
}

// Body
class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Image
class _Images extends StatelessWidget {
  const _Images({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
