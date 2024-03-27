import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

// @author zosu
// @since 2024-03-27
// @comment 대부분의 Pagination의 구성 = meta + data
@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> {

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
