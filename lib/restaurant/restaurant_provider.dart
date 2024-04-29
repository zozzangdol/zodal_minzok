import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_model.dart';
import 'package:zodal_minzok/restaurant/repository/restaurant_repository.dart';

// @author zosu
// @since 2024-04-29
// @comment RestaurantStateNotifier

final restaurantStateNotifierProvider = StateNotifierProvider<
    RestaurantStateNotifier,
    List<RestaurantModel>>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({required this.repository}) : super([]) {
    paginate();
  }

  paginate() async {
    final resp = await repository.paginate();

    state = resp.data;
  }
}