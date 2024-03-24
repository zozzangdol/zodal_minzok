import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/layout/default_layout.dart';
import 'package:zodal_minzok/common/screen/root_tab.dart';
import 'package:zodal_minzok/user/view/login_screen.dart';

/// @author zosu
/// @since 2024-03-23
/// @comment Token Check 및 최초 호출 데이터 등등
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Token 확인하기
    checkToken();
  }


  // @author zosu
  // @since 2024-03-23
  // @comment Token 확인하기
  void checkToken() async {
    final storage = FlutterSecureStorage();
    final dio = Dio();

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          )
      );

      await storage.write(
          key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => RootTab()), (route) => false);
    } catch (e) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 2,
            ),
            const SizedBox(
              height: 32.0,
            ),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
