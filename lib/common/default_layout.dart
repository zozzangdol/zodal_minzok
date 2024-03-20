import 'package:flutter/material.dart';

/**
* @author zosu
* @since 2024-03-20
* @comment 공통 요소 적용을 위한 디폴트 스크린
**/
class DefaultScreen extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigatorBar; // 화면에 따라 유,무가 다름

  const DefaultScreen({super.key, required this.child, this.backgroundColor, this.title, this.bottomNavigatorBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigatorBar,
    );
  }

  /**
  * @author zosu
  * @since 2024-03-20
  * @comment 상단바 구현
  **/
  AppBar? renderAppBar(){

    if(title == null) {
      // 상단바 없는 화면
      return null;
    } else {
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          title!, // 널 체크 이미 완료
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor:  Colors.black,
      );
    }
  }
}
