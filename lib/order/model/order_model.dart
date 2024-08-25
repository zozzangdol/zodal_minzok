// @author zosu
// @since 2024-08-25
// @comment 주문 모델

import 'package:json_annotation/json_annotation.dart';
import 'package:zodal_minzok/common/model/model_with_id.dart';
import 'package:zodal_minzok/common/utils/data_utils.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_model.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderProductModel {

  factory OrderProductModel.fromJson(Map<String, dynamic> json)
  => _$OrderProductModelFromJson(json);

  OrderProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price
});
  final String id;
  final String name;
  final String detail;
  @JsonKey(
    fromJson: DataUtils.pathToUrl
        
  )
  final String imgUrl;
  final int price;
}

@JsonSerializable()
class OrderProductAndCountModel {
  final OrderProductModel product;
  final int count;
  
  OrderProductAndCountModel({
    required this.product,
    required this.count
});
  
  factory OrderProductAndCountModel.fromJson(Map<String, dynamic> json)
  => _$OrderProductAndCountModelFromJson(json);
}

@JsonSerializable()
class OrderModel implements IModelWithId{
  final String id;
  final List<OrderProductAndCountModel> products;
  final RestaurantModel restaurant;
  @JsonKey(
    fromJson: DataUtils.stringToDateTime,
  )
  final DateTime creadtedAt;
  
  OrderModel({
    required this.id,
    required this.products,
    required this.restaurant,
    required this.creadtedAt
});
  
  factory OrderModel.fromJson(Map<String, dynamic> json)
  => _$OrderModelFromJson(json);
}