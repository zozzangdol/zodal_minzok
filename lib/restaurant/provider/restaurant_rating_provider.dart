import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/restaurant/repository/restaurant_rating_repository.dart';

class RestaurantRatingStateNotifier extends StateNotifier<CursorPaginationBase> {

  RestaurantRatingStateNotifier({required this.repository}) : super(CursorPaginationLoading());
  final RestaurantRatingRepository repository;


}