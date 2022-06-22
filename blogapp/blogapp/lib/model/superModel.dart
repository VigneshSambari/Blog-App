// ignore_for_file: non_constant_identifier_names, file_names

import 'package:blogapp/model/addBlogModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'superModel.g.dart';

@JsonSerializable()
class SuperModel {
  List<AddBlogModel>? data;
  SuperModel({this.data});

  factory SuperModel.fromJson(Map<String, dynamic> json) =>
      _$SuperModelFromJson(json);
  Map<String, dynamic> toJson() => _$SuperModelToJson(this);
}
