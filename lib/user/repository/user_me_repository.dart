// @author zosu
// @since 2024-08-24
// @comment User Info Repository


import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/dio/dio.dart';
import 'package:zodal_minzok/user/model/basket_item_model.dart';
import 'package:zodal_minzok/user/model/patch_basket_body.dart';
import 'package:zodal_minzok/user/model/user_model.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final Dio dio = ref.watch(dioProvider);

  return UserMeRepository(dio, baseUrl: 'http://$ip/user/me');
});
@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl})= _UserMeRepository;

  @GET('/')
  @Headers({
    'accessToken' : 'true'
  })
  Future<UserModel> getMe();

  /// 장바구니 조회
  @GET('/basket')
  @Headers({
    'accessToken' : 'true'
  })
  Future<List<BasketItemModel>> getBasket();

  /// 장바구니 담기
  @PATCH('/basket')
  @Headers({
    'accessToken' : 'true'
  })
  Future<List<BasketItemModel>> patchBasket({
    @Body() required PatchBasketBody body
});

}
