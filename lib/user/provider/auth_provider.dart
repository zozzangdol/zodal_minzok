import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zodal_minzok/common/screen/root_tab.dart';
import 'package:zodal_minzok/common/screen/splash_screen.dart';
import 'package:zodal_minzok/common/security_storage/security_storage.dart';
import 'package:zodal_minzok/order/view/order_done_screen.dart';
import 'package:zodal_minzok/restaurant/view/basket_screen.dart';
import 'package:zodal_minzok/restaurant/view/restaurant_detail_screen.dart';
import 'package:zodal_minzok/user/model/user_model.dart';
import 'package:zodal_minzok/user/provider/user_me_provider.dart';
import 'package:zodal_minzok/user/view/login_screen.dart';

final authProvider = ChangeNotifierProvider((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
        path: '/', /// home
        name: RootTab.routeName,
        builder: (_, __) => RootTab(),
        routes: [
          GoRoute(
            path: 'restaurant:rid',
            name: RestaurantDetailScreen.routeName,
            builder: (_, state) =>
                RestaurantDetailScreen(id: state.pathParameters['rid']!),
          ),
        ]),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen(),
    ),
    GoRoute(
      path: '/basket',
      name: BasketScreen.routeName,
      builder: (_, __) => BasketScreen(),
    ),
    GoRoute(
      path: '/order_done',
      name: OrderDoneScreen.routeName,
      builder: (_, __) => OrderDoneScreen(),
    ),
  ];

  /// SplashScreen
  /// 앱을 처음 시작했을 때
  /// 토큰 존재 확인 -> 로그인 스크린 or 홈 스크린
  Future<String?> redirectLogic(GoRouterState state) async {
    final UserModelBase? user = ref.read(userMeProvider);

    /// 로그인 화면에 있는지 (로그인 중) 확인
    final logginIn = state.location == '/login';

    /// 유저정보가 없는데
    /// 로그인 중이면 그대로 로그인 페이지에 두고
    /// 로그인 중이 아닌 상태이면 로그인 페이지로 이동
    if (user == null) {
      return logginIn ? null : '/login';
    }

    /// user가 null이 아님

    /// 1. UserModel
    /// 사용자 정보가 있는 상태면
    /// 로그인 중이거나 현재 위치가 SplashScreen -> Home으로 이동
    if (user is UserModel) {
      return (logginIn || state.location == '/splash') ? '/' : null;
    }

    /// 2. UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    /// 나머지는 원래 이동하려던 페이지로 이동
    return null;
  }

  logout(){
    ref.read(userMeProvider.notifier).logout();
  }
}
