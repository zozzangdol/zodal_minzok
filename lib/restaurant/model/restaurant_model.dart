// @author zosu
// @since 2024-03-24
// @comment 가게 모델

import 'package:json_annotation/json_annotation.dart';
import 'package:zodal_minzok/common/utils/data_utils.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel {
  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantModelFromJson(json);

  // 2024-03-24 json_serializable 대체
  // factory RestaurantModel.fromJson({
  //   required Map<String, dynamic> json
  // }) {
  //   return RestaurantModel(id: json['id'],
  //       name: json['name'],
  //       thumbUrl: 'http://$ip${json['thumbUrl']}',
  //       tags: List<String>.from(json['tags']),
  //       priceRange: RestaurantPriceRange.values.firstWhere((element) => element
  //           .name == json['priceRange']),
  //       ratings: json['ratings'],
  //       ratingsCount: json['ratingsCount'],
  //       deliveryTime: json['deliveryTime'],
  //       deliveryFee: json['deliveryFee']);
  // }
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;
}