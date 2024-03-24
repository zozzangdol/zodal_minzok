
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_detail_model.dart';

part 'restaurant_repository.g.dart';
// @author zosu
// @since 2024-03-24
// @comment Restaurant Repository

@RestApi()
abstract class RestaurantRepository {
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository;

  @GET('/{id}')
  @Headers({
    'authorization' : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0IjoxNzExMjg0MDY4LCJleHAiOjE3MTEyODQzNjh9.-jSNDXs6jXon6Gwkvc7U0t9SeCfF1IuC55E8B5Uu20I'
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}