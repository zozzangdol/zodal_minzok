import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/dio/dio.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/common/model/pagination_params.dart';
import 'package:zodal_minzok/common/repository/base_pagination_repository.dart';
import 'package:zodal_minzok/rating/model/rating_model.dart';

// @author zosu
// @since 2024-06-26
// @comment 레스토랑 후기 Repository

part 'restaurant_rating_repository.g.dart';


final restaurantRatingRepositoryProvider = Provider.family<
    RestaurantRatingRepository,
    String>((ref, id) {

      Dio dio = ref.watch(dioProvider);

      return RestaurantRatingRepository(dio, baseUrl: 'http://$ip/restaurant/$id/rating');

});

@RestApi()
abstract class RestaurantRatingRepository implements IBasePaginationRepository<RatingModel>{

  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
  _RestaurantRatingRepository;

  // restaurant/:rid/rating
  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams ? paginationParams = const PaginationParams(),
  });
}
