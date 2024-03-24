import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_model.dart';

import '../model/restaurant_detail_model.dart';

// @author zosu
// @since 2024-03-24
// @comment 가게 카드

class RestaurantCard extends StatelessWidget {
  // 이미지
  final Widget image;

  // 가게 이름
  final String name;

  // 가게 태그
  final List<String> tags;

  // 평점수
  final int ratingCount;

  // 배달 시간
  final int deliveryTime;

  // 배달 요금
  final int deliveryFee;

  // 별점
  final double ratings;

  // 상세 카드 여부
  final bool isDetail;

  // 상세 내용
  final String? detail;

  const RestaurantCard(
      {Key? key,
      required this.image,
      required this.name,
      required this.tags,
      required this.ratingCount,
      required this.deliveryTime,
      required this.deliveryFee,
      required this.ratings,
      this.isDetail = false,
      this.detail})
      : super(key: key);

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(
        model.thumbUrl,
        fit: BoxFit.cover,
      ),
      name: model.name,
      tags: model.tags,
      ratingCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
          child: image,
        ),
        SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16.0 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                tags.join(' * '),
                style: const TextStyle(fontSize: 14.0, color: BODY_TEXT_COLOR),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  _IconText(
                    icon: Icons.star,
                    label: ratings.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.receipt,
                    label: ratingCount.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '$deliveryTime 분',
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.monetization_on,
                    label: deliveryFee == 0 ? '무료' : deliveryFee.toString(),
                  )
                ],
              ),
              if (detail != null && isDetail)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text(detail!),
                )
            ],
          ),
        )
      ],
    );
  }

  Widget renderDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ' * ',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// @author zosu
// @since 2024-03-24
// @comment 공통 아이콘

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 16.0,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
