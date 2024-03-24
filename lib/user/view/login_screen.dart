import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zodal_minzok/common/component/custom_text_form_field.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/layout/default_layout.dart';
import 'package:zodal_minzok/common/screen/root_tab.dart';

/// @author zosu
/// @since 2024-03-20
/// @comment 로그인 화면
///
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    return DefaultScreen(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // UI/UX 편의상
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(
                  height: 16.0,
                ),
                _SubTitle(),
                const SizedBox(
                  height: 16.0,
                ),
                Image.asset('asset/img/misc/logo.png', height: MediaQuery.of(context).size.height/3,),
                const SizedBox(
                  height: 32.0,
                ),
                CustomTextformfield(
                  onChanged: (value){
                    username = value;
                  },
                  hintText: '이메일을 입력하세요',
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextformfield(
                  onChanged: (value){
                    password = value;
                  },
                  hintText: '비밀번호를 입력하세요',
                ),
                const SizedBox(
                  height: 32.0,
                ),
                ElevatedButton(onPressed: () async {
                  // ID:비밀번호
                  final rawString = '$username:$password';

                  // Encoding 정의
                  Codec<String, String> stringToBase64 = utf8.fuse(base64);

                  // Encoding
                  String token = stringToBase64.encode(rawString);

                  final resp = await dio.post(
                    'http://$ip/auth/login',
                    options: Options(
                      headers: {
                        'authorization' : 'Basic $token'
                      },
                    )
                  );

                  final refreshToken = resp.data['refreshToken'];
                  final accessToken = resp.data['accessToken'];

                  final storage = FlutterSecureStorage();

                  await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                  await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_)=>RootTab())
                  );

                }, style:
                    ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR
                    ), child: const Text('로그인', style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold,
                ),),),
                ElevatedButton(onPressed: (){}, style:
                ElevatedButton.styleFrom(
                    foregroundColor: Colors.black
                ), child: const Text('회원가입'),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/**
* @author zosu
* @since 2024-03-20
* @comment 로그인 화면 타이틀
**/
class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '어서오세요!',
      style: TextStyle(
        fontSize: 34.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

/**
* @author zosu
* @since 2024-03-20
* @comment 타이틀 밑 서브 타이틀
**/
class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요! \n오늘도 돈 많이 쓰시길!',
      style: TextStyle(
        fontSize: 16.0,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
