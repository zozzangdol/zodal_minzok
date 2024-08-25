import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/layout/default_layout.dart';
import 'package:zodal_minzok/common/screen/root_tab.dart';

class OrderDoneScreen extends StatelessWidget {
  static String get routeName => 'order_done';
  const OrderDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.thumb_up_alt_outlined, color: PRIMARY_COLOR, size: 50.0,),
        const SizedBox(
          height: 32.0,
        ),
        Text('결제가 완료되었습니다'),
        const SizedBox(
          height: 32.0,
        ),
        ElevatedButton(onPressed: (){
          context.goNamed(RootTab.routeName);
        }, child: Text('Go Home'))
      ],
    ));
  }
}
