import 'package:flutter/material.dart';
import 'package:zodal_minzok/common/component/custom_text_form_field.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/default_layout.dart';

/**
 * @author zosu
 * @since 2024-03-20
 * @comment 로그인 화면
 **/
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // UI/UX 편의상
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                SizedBox(
                  height: 16.0,
                ),
                _SubTitle(),
                SizedBox(
                  height: 16.0,
                ),
                Image.asset('asset/img/misc/logo.png', height: MediaQuery.of(context).size.height/3,),
                SizedBox(
                  height: 32.0,
                ),
                CustomTextformfield(),
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
