// @author zosu
// @since 2024-08-24
// @comment User Info Provider


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/security_storage/security_storage.dart';
import 'package:zodal_minzok/user/model/user_model.dart';
import 'package:zodal_minzok/user/repository/auth_repository.dart';
import 'package:zodal_minzok/user/repository/user_me_repository.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref){
      final authRepository = ref.watch(authRepositoryProvider);
      final userMeRepository = ref.watch(userMeRepositoryProvider);
      final storage = ref.watch(secureStorageProvider);

      return UserMeStateNotifier(authRepository: authRepository, repository: userMeRepository, storage: storage);
    });

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  UserMeStateNotifier(
      {required this.authRepository,
      required this.repository,
      required this.storage})
      : super(UserModelLoading()) {
    /// 내 정보 가져오기
    getMe();
  }

  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  Future<void> getMe() async {
    /// null 검증 먼저 진행
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    final resp = await repository.getMe();

    state = resp;
  }

  Future<UserModelBase> login(
      {required String userName, required String password}) async {
    try {
      /// 로그인 시작과 동시에 로딩 처리
      state = UserModelLoading();

      /// 로그인 호출
      final resp =
          await authRepository.Login(userName: userName, password: password);

      /// token 저장
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      /// token에 해당하는 유저 정보 가져올 뿐만 아니라 token 검증
      final userResp = await repository.getMe();

      state = userResp;

      return userResp;

      /// 데이터를 활용할 수도 있어 리턴
    } catch (e) {
      state = UserModelError(error: '로그인에 실패했습니다');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    print('logout');
    /// 시작과 동시에 null 처리
    state = null;

    /// token 삭제
    /// await 한번에 진행하려면 아래처럼 동시에 시작하여 모두 끝나면 끝
    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY)
    ]);
  }
}
