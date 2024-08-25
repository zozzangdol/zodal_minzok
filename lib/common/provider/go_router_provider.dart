import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zodal_minzok/common/screen/root_tab.dart';
import 'package:zodal_minzok/common/screen/splash_screen.dart';
import 'package:zodal_minzok/restaurant/view/restaurant_detail_screen.dart';
import 'package:zodal_minzok/user/provider/auth_provider.dart';
import 'package:zodal_minzok/user/view/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref){
  /// watch - 값이 변경될때마다 다시 빌드
  /// read - 한번만 읽고 값이 변경돼도 다시 빌드 X
  /// go router의 instance는 변경 없이 같은 instance 사용해야함
  /// 실질적으로 코드상 변동될일은 없어 watch나 read나 실 사용은 동일하지만 의미를 알아둬라
  final provider = ref.read(authProvider);

    return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
    redirect: (_, state)=> provider.redirectLogic(state),
  );
});
