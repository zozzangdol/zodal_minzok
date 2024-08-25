
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/dio/dio.dart';
import 'package:zodal_minzok/common/model/login_response.dart';
import 'package:zodal_minzok/common/model/token_response.dart';
import 'package:zodal_minzok/common/utils/data_utils.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref){
  final Dio dio = ref.watch(dioProvider);

  return AuthRepository(baseUrl: 'http://$ip/auth', dio: dio);
});
class AuthRepository {
  /// http://$ip/auth
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio
  });

  // @author zosu
  // @since 2024-08-24
  // @comment Login
  Future<LoginResponse> Login({required String userName, required String password}) async{
    final encoded = DataUtils.plainToBase64('$userName:$password');

    final resp = await dio.post(
        '$baseUrl/login',
        options: Options(
          headers: {
            'authorization' : 'Basic $encoded'
          },
        )
    );

    return LoginResponse.fromJson(resp.data);
  }


  // @author zosu
  // @since 2024-08-24
  // @comment accessToken 발급
  Future<TokenResponse> token() async {
    final resp = await dio.post(
        '$baseUrl/token',
        options: Options(
            headers: {
              'refreshToken' : 'true'}
        )
    );

    return resp.data;
  }


}