
// @author zosu
// @since 2024-06-27
// @comment Repository 공통화

import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/common/model/model_with_id.dart';
import 'package:zodal_minzok/common/model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {

  Future<CursorPagination<T>> paginate({
    PaginationParams ? paginationParams = const PaginationParams(),
  });

}
