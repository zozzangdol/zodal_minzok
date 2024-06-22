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
  late ScrollController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = ScrollController();
    _controller.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 최대 길이보다 덜 되는 위치에서 새로운 데이터를 요청
    if (_controller.offset >= _controller.position.maxScrollExtent - 300) {
      //pagination 로직 한번 더 확인
      ref
          .watch(restaurantStateNotifierProvider.notifier)
          .paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantStateNotifierProvider);

    // 맨 처음 로딩할 때
    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러가 발생
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.error),
      );
    }

    // 아래 세가지는 모두 CursorPagination
    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetch

    // 임시
    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: ListView.separated(
          controller: _controller,
          itemBuilder: (_, index) {
            /// 데이터를 더 조회하고 있을 시 로딩 
            if (index == cp.data.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: cp is CursorPaginationFetchingMore /// 데이터가 더이상 없을때 로딩창을 보여주면 안됨
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Text(
                        '마지막 페이지 입니다 ㅠㅠ',
                      ), 
              );
            }
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
          itemCount: cp.data.length + 1),
    );
  }
}
