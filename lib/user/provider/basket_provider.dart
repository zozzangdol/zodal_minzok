// @author zosu
// @since 2024-08-25
// @comment 장바구니 프로바이더

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/product/model/product_model.dart';
import 'package:zodal_minzok/user/model/basket_item_model.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>(
        (ref) => BasketProvider());

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  BasketProvider() : super([]);

  // @author zosu
  // @since 2024-08-25
  // @comment 장바구니 추가
  Future<void> addToBasket({required ProductModel product}) async {
    /// 1. 아직 장바구니에 해당하는 상품이 없다면
    ///    장바구니에 상품 추가
    /// 2. 만약 이미 들어있다면
    ///    장바구니에 있는 값에 + 1

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    } else {
      state = [...state, BasketItemModel(product: product, count: 1)];
    }
  }

  // @author zosu
  // @since 2024-08-25
  // @comment 장바구니 삭제
  Future<void> removeFromBasket({
    required ProductModel product,

    /// true면 카운트에 관계없이 (강제) 삭제
    bool isDelete = false,
  }) async {
    /// 1. 장바구니에 상품이 존재할때
    ///    a. 삼품의 카운트가 1보다 큼 -> -1
    ///    b. 상품의 카운트가 1       -> 삭제
    /// 2. 장바구니에 상품이 존재하지 않을때
    ///   즉시 함수를 반환하고 아무것도 하지 않음

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    /// 이미 존재함을 체크했음
    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      /// 필터링
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count - 1) : e)
          .toList();
    }
  }
}
