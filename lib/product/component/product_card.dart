import 'package:flutter/material.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_detail_model.dart';

// @author zosu
// @since 2024-03-24
// @comment 가게 상세 페이지의 메뉴 항목

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      required this.image,
      required this.name,
      required this.detail,
      required this.price})
      : super(key: key);

  factory ProductCard.fromModel({
    required RestaurantProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }

  final Image image;
  final String name;
  final String detail;
  final int price;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: image,
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              Text(
                detail,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 14.0,
                ),
              ),
              Text(
                '$price 원',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
