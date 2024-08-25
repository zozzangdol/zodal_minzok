import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zodal_minzok/common/screen/root_tab.dart';
import 'package:zodal_minzok/common/screen/splash_screen.dart';
import 'package:zodal_minzok/restaurant/view/restaurant_detail_screen.dart';
import 'package:zodal_minzok/user/provider/auth_provider.dart';
import 'package:zodal_minzok/user/view/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref){
  final provider = ref.watch(authProvider);

  return GoRouter(
      redirect: (_, state) => provider.redirectLogic(state),
      routes: [
        GoRoute(
            path: '/', /// home
            name: RootTab.routeName,
            builder: (_, __) => RootTab(),
            routes: [
              GoRoute(
                path: 'restaurant/:rid',
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
      ]
  );
});
