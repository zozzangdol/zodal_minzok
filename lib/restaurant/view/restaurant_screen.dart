import 'package:flutter/material.dart';
import 'package:zodal_minzok/common/component/pagination_list_view.dart';
import 'package:zodal_minzok/restaurant/component/restaurant_card.dart';
import 'package:zodal_minzok/restaurant/provider/restaurant_provider.dart';
import 'package:zodal_minzok/restaurant/view/restaurant_detail_screen.dart';


// @author zosu
// @since 2024-03-24
// @comment 가게 리스트

class RestaurantScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return PaginationListView(provider: restaurantStateNotifierProvider,
      itemBuilder: <RestaurantModel>(context, index, model) {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(
                  id: model.id,
                )));
          },
          child: RestaurantCard.fromModel(model: model));
    },);

  }
}
