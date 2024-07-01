
// @author zosu
// @since 2024-06-25
// @comment 리뷰 리스트
import 'package:json_annotation/json_annotation.dart';
import 'package:zodal_minzok/common/model/model_with_id.dart';
import 'package:zodal_minzok/common/utils/data_utils.dart';
import 'package:zodal_minzok/user/model/user_model.dart';

part 'rating_model.g.dart';
@JsonSerializable()
class RatingModel implements IModelWithId {
  final String id;
  final UserModel user;
  final int rating;
  final String content;
  @JsonKey(
    fromJson: DataUtils.listPathToUrl
  )
  final List<String> imgUrls;

  RatingModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.content,
    required this.imgUrls
});

  factory RatingModel.fromJson(Map<String, dynamic> json)
  => _$RatingModelFromJson(json);
}
