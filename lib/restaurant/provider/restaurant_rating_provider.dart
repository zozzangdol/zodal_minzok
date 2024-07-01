import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/common/provider/pagination_provider.dart';
import 'package:zodal_minzok/rating/model/rating_model.dart';
import 'package:zodal_minzok/restaurant/repository/restaurant_rating_repository.dart';


final restaurantRatingStateProvider = StateNotifierProvider.family<
    RestaurantRatingStateNotifier,
    CursorPaginationBase, String>((ref, id) {

      final repo = ref.watch(restaurantRatingRepositoryProvider(id));

      return RestaurantRatingStateNotifier(repository: repo);
});

class RestaurantRatingStateNotifier
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingStateNotifier({required super.repository});

}