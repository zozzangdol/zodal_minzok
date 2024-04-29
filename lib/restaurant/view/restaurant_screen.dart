import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zodal_minzok/common/dio/dio.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/restaurant/component/restaurant_card.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_model.dart';
import 'package:zodal_minzok/restaurant/repository/restaurant_repository.dart';
import 'package:zodal_minzok/restaurant/restaurant_provider.dart';
import 'package:zodal_minzok/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';

// @author zosu
// @since 2024-03-24
// @comment 가게 리스트
class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {


  @override
  Widget build(BuildContext context) {

    final data = ref.watch(restaurantStateNotifierProvider);

    if(data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // 임시
    final cp = data as CursorPagination;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: ListView.separated(
            itemBuilder: (_, index) {
              // final item = snapshot.data![index]; // respository에서 바로 매핑
              final pItem = cp.data[index];

              return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(
                          id: pItem.id,
                        )));
                  },
                  child: RestaurantCard.fromModel(model: pItem));
            },
            separatorBuilder: (_, index) {
              return SizedBox(
                height: 16.0,
              );
            },
            itemCount: cp.data.length),
      ),
    );
  }
}
