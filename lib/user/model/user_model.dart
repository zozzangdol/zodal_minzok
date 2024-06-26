import 'package:json_annotation/json_annotation.dart';
import 'package:zodal_minzok/common/utils/data_utils.dart';

// @author zosu
// @since 2024-06-25
// @comment 사용자 모델

part 'user_model.g.dart';
@JsonSerializable()
class UserModel {
  final String id;
  final String username;
  @JsonKey(
      fromJson: DataUtils.pathToUrl
  )
  final String imageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.imageUrl
});

  factory UserModel.fromJson(Map<String, dynamic> json)
  => _$UserModelFromJson(json);

}