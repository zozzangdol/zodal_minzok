
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/common/provider/pagination_provider.dart';
import 'package:zodal_minzok/product/model/product_model.dart';
import 'package:zodal_minzok/product/repository/product_repository.dart';

// @author zosu
// @since 2024-07-01
// @comment 상품 프로바이더

final productProvider = StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(productRepositoryProvider);

  return ProductStateNotifier(repository: repo);
});

class ProductStateNotifier extends PaginationProvider<ProductModel, ProductRepository> {

  ProductStateNotifier({required super.repository});
}
