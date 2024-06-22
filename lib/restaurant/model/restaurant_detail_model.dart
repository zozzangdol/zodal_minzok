import 'package:json_annotation/json_annotation.dart';
import 'package:zodal_minzok/common/utils/data_utils.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_model.dart';
part 'restaurant_detail_model.g.dart';
// @author zosu
// @since 2024-03-24
// @comment 가게 디테일 화며 모델 (가게 모델과 공통 부분이 많으므로 상속)

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products
  });
  
  
  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantDetailModelFromJson(json);

  final String detail;
  final List<RestaurantProductModel> products;
}

// @author zosu
// @since 2024-03-24
// @comment 가게 판매 물품 모델

@JsonSerializable()
class RestaurantProductModel {

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantProductModelFromJson(json);


  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl
  )
  final String imgUrl;
  final String detail;
  final int price;
}