import 'package:flutter/material.dart';
import 'package:zodal_minzok/common/component/pagination_list_view.dart';
import 'package:zodal_minzok/restaurant/component/restaurant_card.dart';
import 'package:zodal_minzok/restaurant/provider/restaurant_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zodal_minzok/restaurant/view/restaurant_detail_screen.dart';

// @author zosu
// @since 2024-03-24
// @comment 가게 리스트

class RestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantStateNotifierProvider,
      itemBuilder: <RestaurantModel>(buildContext, index, model) {
        return GestureDetector(
            onTap: () {
              context
                  .goNamed(RestaurantDetailScreen.routeName, pathParameters: {'rid': model.id,
              });
              /// 모바일에서는 쿼리파라미터 적게 사용하기
            },
            child: RestaurantCard.fromModel(model: model));
      },
    );
  }
}
