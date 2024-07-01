import 'package:flutter/material.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/layout/default_layout.dart';
import 'package:zodal_minzok/product/view/product_screen.dart';
import 'package:zodal_minzok/restaurant/view/restaurant_screen.dart';

/**
* @author zosu
* @since 2024-03-23
* @comment 루트탭
**/
class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  _RootTabState createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin{
  int index= 0;
  late TabController controller;
  // ?를 사용해 선언하면, 사용할때마다 null 처리 필요
  // late 사용 시 주의할 점은 사용 시에 선언되지 않았을 경우 에러 발생

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.removeListener(tabListener);
  }

  /**
  * @author zosu
  * @since 2024-03-23
  * @comment 선택된 탭 setState
  **/
  void tabListener (){
    setState(() {
      index = controller.index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      title: '조수 딜리버리',
      bottomNavigatorBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          // 이동은 여기서
          // Tab 변환은 controller의 listener에서 진행 
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood_outlined),label: 'FOOD'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined),label: 'ORDER'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined),label: 'PROFILE'),
        ],
      ),
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          RestaurantScreen(),
          ProductScreen(),
          Container(
            child: Text('주문'),
          ),
          Container(
            child: Text('프로필'),
          ),
        ],
      ),
    );
  }
}
