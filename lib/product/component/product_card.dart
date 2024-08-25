import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/product/model/product_model.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_detail_model.dart';
import 'package:zodal_minzok/user/provider/basket_provider.dart';

// @author zosu
// @since 2024-03-24
// @comment 가게 상세 페이지의 메뉴 항목

class ProductCard extends ConsumerWidget {
  const ProductCard(
      {Key? key,
      required this.image,
      required this.name,
      required this.detail,
      required this.price,
      required this.id,
      this.onSubtract,
      this.onAdd})
      : super(key: key);

  factory ProductCard.fromModel({
    required ProductModel model,
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
      id: model.id,
      onSubtract: onSubtract,
      onAdd: onAdd,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
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
      onSubtract: onSubtract,
      onAdd: onAdd,
      id: model.id,
    );
  }

  final Image image;
  final String name;
  final String detail;
  final int price;

  final VoidCallback? onSubtract; /// 장바구니 빼기
  final VoidCallback? onAdd; /// 장바구니 담기

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: image,
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w500),
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
        ),
        if(onSubtract != null && onAdd != null)
        Padding(
          padding: const EdgeInsets.only(top : 8.0),
          child: _Footer(
              total: (basket.firstWhere((element) => element.product.id == id).count *
                    basket.firstWhere((element) => element.product.id == id).product.price).toString(),
              count: basket.firstWhere((element) => element.product.id == id).count,
              onSubtract: onSubtract!,
              onAdd: onAdd!),
        )
      ],
    );
  }
}

// @author zosu
// @since 2024-08-25
// @comment 장바구니용
class _Footer extends StatelessWidget {
  final String total;
  final int count; // 총 갯수
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  const _Footer({required this.total, required this.count, required this.onSubtract, required this.onAdd, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 $total',
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            renderButton(icon: Icons.remove, onTap: onSubtract),
            SizedBox(width: 8.0,),
            Text(
              count.toString(),
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.0,),
            renderButton(icon: Icons.add, onTap: onAdd)
          ],
        )
      ],
    );
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
}){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0,),
        border: Border.all(
          color: PRIMARY_COLOR,
          width: 1.0,
        )
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
