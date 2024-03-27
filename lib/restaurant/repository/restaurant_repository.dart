
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_detail_model.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../model/restaurant_model.dart';

part 'restaurant_repository.g.dart';
// @author zosu
// @since 2024-03-24
// @comment Restaurant Repository

@RestApi()
abstract class RestaurantRepository {
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository;


  @GET('/')
  @Headers({
    'accessToken' : 'true'
  })
  Future<CursorPagination<RestaurantModel>> paginate();

  @GET('/{id}')
  @Headers({
    'accessToken' : 'true'
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}