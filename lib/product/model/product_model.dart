

// @author zosu
// @since 2024-07-01
// @comment 음식 모델
import 'package:json_annotation/json_annotation.dart';
import 'package:zodal_minzok/common/model/model_with_id.dart';
import 'package:zodal_minzok/common/utils/data_utils.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_model.dart';

part 'product_model.g.dart';
@JsonSerializable()
class ProductModel implements IModelWithId {
  final String id;

  // 이름
  final String name;
  // 이미지 링크
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  // 상품설명
  final String detail;
  // 가격
  final int price;
  // 레스토랑 정보
  final RestaurantModel restaurant;

  ProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
    required this.restaurant,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json)
  => _$ProductModelFromJson(json);

}
