

// @author zosu
// @since 2024-07-01
// @comment 상품 Repository


import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/dio/dio.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/common/model/pagination_params.dart';
import 'package:zodal_minzok/common/repository/base_pagination_repository.dart';
import 'package:zodal_minzok/product/model/product_model.dart';


part 'product_repository.g.dart';


// repository provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
      final Dio dio = ref.watch(dioProvider);
      return ProductRepository(dio, baseUrl: 'http://$ip/product');

});

@RestApi()
abstract class ProductRepository extends IBasePaginationRepository<ProductModel> {

  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<ProductModel>> paginate({
    @Queries() PaginationParams ? paginationParams = const PaginationParams(),
  });

}
