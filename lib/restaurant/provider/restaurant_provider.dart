import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/common/provider/pagination_provider.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_model.dart';
import 'package:zodal_minzok/restaurant/repository/restaurant_repository.dart';
import 'package:collection/collection.dart';

// @author zosu
// @since 2024-04-29
// @comment RestaurantStateNotifier

// @author zosu
// @since 2024-06-22
// @comment Restaurant Detail Screen에서 보여질 데이터 중 Restaurant Screen과 동일한 데이터 
final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
      
      final state = ref.watch(restaurantStateNotifierProvider);
      
      if(state is! CursorPagination){
        return null;
      }

      return state.data.firstWhereOrNull((element) => element.id == id);
    });

final restaurantStateNotifierProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({required super.repository});

  // @author zosu
  // @since 2024-06-22
  // @comment ReastaurantDetail 캐시처리
  void getDetail(String id) async {

    if(state is! CursorPagination) {
      // 데이터가 없는 상태 -> 가져오는 시도
      await this.paginate();
    }

    if(state is! CursorPagination) {
      // 요청을 했음에도 불구하고 데이터 없을 시
      return;
    }

    final pState = state as CursorPagination<RestaurantModel>;

    final resp = await repository.getRestaurantDetail(id: id);

    /// 음식 탭에서 getDetail()시 매핑하려는 레스토랑 데이터가 없어서 오류 발생 처리

    if(pState.data.where((element) => element.id == id).isEmpty) {

      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          resp,
        ]
      );

    } else {
      // 가져온 Detail Data로 교체
      state = pState.copyWith(
        data: pState.data.map((e) => e.id == id ? resp : e ).toList(),
      );
    }
  }
}
