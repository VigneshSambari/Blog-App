// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'profileModel.g.dart';

@JsonSerializable()
class ProfileModel {
  String name;
  String username;
  String profession;
  String DOB;
  String titleline;
  String about;
  ProfileModel(
      {this.DOB = "",
      this.about = "",
      this.name = "",
      this.profession = "",
      this.titleline = "",
      this.username = ""});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
