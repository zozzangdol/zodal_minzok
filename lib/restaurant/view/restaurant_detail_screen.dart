import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/dio/dio.dart';
import 'package:zodal_minzok/common/layout/default_layout.dart';
import 'package:zodal_minzok/product/component/product_card.dart';
import 'package:zodal_minzok/restaurant/component/restaurant_card.dart';
import 'package:zodal_minzok/restaurant/repository/restaurant_repository.dart';

import '../model/restaurant_detail_model.dart';

// @author zosu
// @since 2024-03-24
// @comment 가게 상세 화면

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key, required this.id});

  final String id;

  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    // Interceptor 적용
    final storage = FlutterSecureStorage();
    dio.interceptors.add(CustomInterceptor(storage: storage));

    final repository = RestaurantRepository(dio,  baseUrl: 'http://$ip/restaurant');

    return repository.getRestaurantDetail(id: id);
  }

  // 2024-03-34 Repository에서 바로 호출로 변경
  // Future<Map<String, dynamic>> getRestaurantDetail() async {
  //   final dio = Dio();
  //   final storage = FlutterSecureStorage();
  //
  //   final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
  //   final resp = await dio.get(
  //     'http://$ip/restaurant/$id',
  //     options: Options(
  //       headers: {
  //         'authorization' : 'Bearer $accessToken'
  //       }
  //     ),
  //   );
  //   return resp.data;
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // final item = RestaurantDetailModel.fromJson(snapshot.data!);
          // 2024-03-24 repository에서 이미 Model Mapping이 완료 => 바로 snapshot.data 사용 가능

          return CustomScrollView(
            slivers: [
              renderTop(model: snapshot.data!),
              renderLabel(),
              renderProduct(products: snapshot.data!.products),
            ],
          );
        },
        future: getRestaurantDetail(),
      ),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantDetailModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProduct(
      {required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];

          return Padding(
            padding: EdgeInsets.only(
              top: 16.0,
            ),
            child: ProductCard.fromModel(model: product),
          );
        }, childCount: products.length),
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
