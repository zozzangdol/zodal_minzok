import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/common/model/pagination_params.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_model.dart';
import 'package:zodal_minzok/restaurant/repository/restaurant_repository.dart';

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
      
      return state.data.firstWhere((element) => element.id == id);
    });

final restaurantStateNotifierProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({required this.repository})
      : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false, // true: 추가로 데이터 조회 (무조건 기존 데이터 존재)
    bool forceRefetch = false, // true : 강제로 로딩
  }) async {
    try {
      // state는 5가지 상태로 존재 가능
      // 1. CursorPagination : 정상적으로 데이터 존재
      // 2. CursorPaginationLoading : 데이터가 로딩중인 상태 (현재 캐시 X)
      // 3. CursorPaginationError : 에러
      // 4. CursorPaginationRefetching : 첫번째 데이터부터 다시 가져올 때
      // 5. CursorPaginationFetchingMore : 추가데이터를 가져올 때

      // 복잡한 로직 구현 시 가장 먼저 반환(Return)되는 경우를 먼저 고려하자
      // 첫번째 경우 : hasMore가 false 일 때 (전제 조건 : 기존 상태에서 이미 다음 데이터가 없다는 값을 갖고 있음)
      // 두번째 경우 : 로딩중이고 fetchMore가 true 일 때
      // 로딩중이므로 추가 요청하면 안됨 & fetchMore가 false일 경우, 새로고침의 가능성이 있으므로

      // 첫번째 경우
      if (state is CursorPagination && !forceRefetch) {
        // state is CursorPagination : 기존 상태에서 데이터 들고 있음
        // !forceRefetch : forceRefecth가 true이면 반환(return)이 아니라 추가적으로 해야할 일이 있음

        final pState = state as CursorPagination; // 형변환 (명시!!!!!!!!!!!!)

        if (!pState.meta.hasMore) {
          return;
        }
      }

      // 두번째 경우
      // 로딩중인 상태 = 세 가지
      final isLoading = state is CursorPaginationLoading;
      final isFetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isFetching || isFetchingMore)) {
        return;
      }

      // 먼저 반환 시킨 이후의 로직

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      if (fetchMore) {
        // 데이터를 추가 조회
        final pState = state
            as CursorPagination; // 설계상 fetchMore = true -> 기존에 이미 데이터 들고있는 상태!!!

        // 기존 데이터를 넣은 상태로
        // UI 단에서는 추가 데이터를 불러오는 상태임을 인지 가능
        state =
            CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id, // 추가 조회하는 경우에만 after에 id
        );
      } else {
        // 데이터를 "처음"부터 조회해오는 상황 (앱 처음 또는 새로고침)

        // 데이터가 있는 상황에서 새로고침
        // 기존 데이터 보존 & Fetch 진행 (날리고 로딩하면 유저 사용시 느린 느낌)
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;
          state =
              CursorPaginationRefetching(meta: pState.meta, data: pState.data);
        } else {
          // 나머지 상황
          state = CursorPaginationLoading();
        }
      }

      final resp =
          await repository.paginate(paginationParams: paginationParams);

      // paginate 호출 후
      if (state is CursorPaginationFetchingMore) {
        print('여기 안오니?');
        final pState = state as CursorPaginationFetchingMore;

        // meta는 resp에서 받은 것이 최신이므로 그대로 두고, data만 추가 업데이트
        state = resp.copyWith(data: [
          ...pState.data, // 기존 데이터
          ...resp.data, // 추가로 조회해온 데이터
        ]);
      } else {
        // refetching 또는 Loading인 경우
        // 추가가 아닌 데이터 쌔삥이 들어가므로 바로 state
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(error: '데이터 조회 실패~');
    }
  }

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

    // 가져온 Detail Data로 교체
    state = pState.copyWith(
      data: pState.data.map((e) => e.id == id ? resp : e ).toList(),
    );
  }
}
