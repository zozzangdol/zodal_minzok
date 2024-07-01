
// @author zosu
// @since 2024-06-28
// @comment Pagination Utils

import 'package:flutter/material.dart';
import 'package:zodal_minzok/common/provider/pagination_provider.dart';

class PaginationUtils {

  // @author zosu
  // @since 2024-06-28
  // @comment 스크롤 기능 공통화

  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
}){
    // 현재 위치가 최대 길이보다 덜 되는 위치에서 새로운 데이터를 요청
    if (controller.offset >= controller.position.maxScrollExtent - 300) {
      provider.paginate(fetchMore: true);
    }
  }

}