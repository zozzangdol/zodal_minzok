import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/layout/default_layout.dart';
import 'package:zodal_minzok/product/component/product_card.dart';
import 'package:zodal_minzok/user/provider/basket_provider.dart';

class BasketScreen extends ConsumerWidget {
  const BasketScreen({super.key});

  static String get routeName => 'basket';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    /// 예외처리
    if (basket.isEmpty) {
      return DefaultScreen(
          title: '장바구니',
          child: Center(child: Text('장바구니가 비어있습니다 ㅠ_ㅠ',)));
    }

    final productTotal = basket
        .fold<int>(
        0, (p, n) => p + n.product.price * n.count);

    final deliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultScreen(
        title: '장바구니',
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, index) {
                      return Divider(
                        height: 32.0,
                      );
                    },
                    itemBuilder: (_, index) {
                      final model = basket[index];

                      return ProductCard.fromModel(
                        model: model.product,
                        onAdd: () {
                          ref
                              .read(basketProvider.notifier)
                              .addToBasket(product: model.product);
                        },
                        onSubtract: () {
                          ref
                              .read(basketProvider.notifier)
                              .removeFromBasket(product: model.product);
                        },
                      );
                    },
                    itemCount: basket.length,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '장바구니 금액',
                          style: TextStyle(
                            color: BODY_TEXT_COLOR,
                          ),
                        ),
                        Text(
                          productTotal.toString(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '배달비',
                          style: TextStyle(
                            color: BODY_TEXT_COLOR,
                          ),
                        ),
                        if(basket.length > 0)
                          Text(
                              deliveryFee.toString()
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '총액',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                            (productTotal + deliveryFee).toString()
                        )
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                        ),
                        onPressed: () {},
                        child: Text(
                          '결제하기',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
