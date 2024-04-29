import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';




abstract class CursorPaginationBase {}

// 에러가 발생 했을 때
class CursorPaginationError extends CursorPaginationBase {
  final String error;

  CursorPaginationError({
    required this.error
  });
}

// 로딩중일 때
class CursorPaginationLoading extends CursorPaginationBase{}

// @author zosu
// @since 2024-03-27
// @comment 대부분의 Pagination의 구성 = meta + data
@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase{
  CursorPagination({
    required this.meta,
    required this.data
});

  factory CursorPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT)
  => _$CursorPaginationFromJson(json, fromJsonT);

  final CursorPaginationMeta meta;
  final List<T> data;

}

@JsonSerializable()
class CursorPaginationMeta {
  CursorPaginationMeta({required this.count, required this.hasMore});
  
  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json)
  => _$CursorPaginationMetaFromJson(json);
  
  final int count;
  final bool hasMore;
}


// 새로고침
class CursorPaginationRefetching extends CursorPagination {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

// 리스트의 마지막 위치에서
// 추가적으로 데이터를 요청 중일때
class CursorPaginationFetchingMore extends CursorPagination {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}