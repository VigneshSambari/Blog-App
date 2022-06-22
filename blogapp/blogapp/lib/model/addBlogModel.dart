// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'addBlogModel.g.dart';

@JsonSerializable()
class AddBlogModel {
  String coverImage;
  @JsonKey(name: "_id")
  String id;
  String username;
  String title;
  String body;
  int comment;
  int like;
  int share;
  AddBlogModel(
      {this.body = "",
      this.id = "",
      this.like = 0,
      this.share = 0,
      this.coverImage = "",
      this.title = "",
      this.comment = 0,
      this.username = ""});

  factory AddBlogModel.fromJson(Map<String, dynamic> json) =>
      _$AddBlogModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddBlogModelToJson(this);
}
