import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/dio/dio.dart';
import 'package:zodal_minzok/common/model/pagination_params.dart';
import 'package:zodal_minzok/common/repository/base_pagination_repository.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_detail_model.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../model/restaurant_model.dart';

part 'restaurant_repository.g.dart';

// @author zosu
// @since 2024-04-22
// @comment RestaurantRepository Provider 작업
final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository =
      RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant/');

  return repository;
});

// @author zosu
// @since 2024-03-24
// @comment Restaurant Repository
@RestApi()
abstract class RestaurantRepository implements IBasePaginationRepository<RestaurantModel> {
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams ? paginationParams = const PaginationParams(),
});

  @GET('/{id}')
  @Headers({'accessToken': 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
