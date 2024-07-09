import 'package:flutter/material.dart';
import 'package:zodal_minzok/common/component/pagination_list_view.dart';
import 'package:zodal_minzok/product/component/product_card.dart';
import 'package:zodal_minzok/product/provider/product_provider.dart';
import 'package:zodal_minzok/restaurant/view/restaurant_detail_screen.dart';

// @author zosu
// @since 2024-06-28
// @comment 음식탭
class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_)=>RestaurantDetailScreen(id: model.restaurant.id))
                );
              },
              child: ProductCard.fromModel(model: model));
        });
  }
}
