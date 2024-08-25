// @author zosu
// @since 2024-03-24
// @comment Token 자동 관리 및 통합 관리를 위한 Interceptor
import 'package:dio/dio.dart' ;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' hide Options;
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/security_storage/security_storage.dart';
import 'package:zodal_minzok/user/provider/auth_provider.dart';
import 'package:zodal_minzok/user/provider/user_me_provider.dart';


final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(CustomInterceptor(storage: storage, ref: ref));

  return dio;
});
class CustomInterceptor extends Interceptor {

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  // 각 상태 발생 시 중간에 가로채서 처리 가능
  // 1. 요청을 보낼 때
  // 2. 응답을 받을 때
  // 3. 에러가 났을 때

  final FlutterSecureStorage storage;
  final Ref ref;

  // 1. 요청을 보낼 때
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}]  ${options.uri}');

    // 요청이 보내질때마다
    // Headers 'accessToken : 'true'
    // => Headers의 accessToken 값을 실제 토큰으로 변경하여 요청

    if(options.headers['accessToken'] == 'true') {
      // 기존 헤더 삭제
      options.headers.remove('accessToken');
      // 실제 토큰
      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization' : 'Bearer $accessToken'
      });
    }

    if(options.headers['refreshToken'] == 'true') {
      // 기존 헤더 삭제
      options.headers.remove('refreshToken');
      // 실제 토큰
      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization' : 'Bearer $refreshToken'
      });
    }

    return super.onRequest(options, handler);
  }

  // 2. 응답이 왔을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // onError와 마찬가지로
    // 응답에 따라 에러를 발생 (reject) 또는 새로운 요청(fetch & resolve) 가능
    return super.onResponse(response, handler);
  }

  // 3. 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 ERROR 발생 시 (해당 서버 설계상 401 Error = Token Error)
    // Access Token 재발급받아 새로운 Token으로 갱신
    print('[ERR] [${err.requestOptions.method}]  ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if(refreshToken == null) {
      // refreshToken이 null이면 재발급이고 뭐고 불가능
      return handler.reject(err); // 에러 발생시킴
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if(isStatus401 && !isPathRefresh) {
      // Access Token 재발급 도중 에러일 경우 굳이 또 재발급 시도 불필요
      final dio = Dio();

      try {

        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {'authorization' : 'Bearer $refreshToken'}
          )
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions; // 에러가 난 기존 요청 옵션들

        // 새로 발급 받은 토큰으로 변경
        options.headers.addAll({
          'authorization' : 'Bearer $accessToken'
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        // 실제로는 중간에 실패했지만, 수정 후 성공한 Response를 리턴하여
        // UI단에서는 에러를 알 수 없음
        return handler.resolve(response);

      } on DioException catch (dioError) {
        /// refreshToken까지 만료됐을때 -> 로그아웃

        /// 1번
        /// Circular Dependency Error
        /// A, B
        /// A -> B 의 친구 , B -> A의 친구
        /// 사람 : A는 B의 친구구나
        /// 컴퓨터 : A -> B -> A -> B.....
        /// 동시에 넣어줘야하는데 동시에 서로를 refer 하고 있음
        /// ref.read(userMeProvider.notifier).logout();

        /// 상위의 객체를 만들어주면 됨 (우회)
        ref.read(authProvider.notifier).logout();
        return handler.reject(dioError);
      }

    }

    return handler.reject(err);
  }
}
