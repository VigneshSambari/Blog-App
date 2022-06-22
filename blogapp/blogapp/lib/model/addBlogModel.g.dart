// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addBlogModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddBlogModel _$AddBlogModelFromJson(Map<String, dynamic> json) => AddBlogModel(
      body: json['body'] as String? ?? "",
      id: json['_id'] as String? ?? "",
      like: json['like'] as int? ?? 0,
      share: json['share'] as int? ?? 0,
      coverImage: json['coverImage'] as String? ?? "",
      title: json['title'] as String? ?? "",
      comment: json['comment'] as int? ?? 0,
      username: json['username'] as String? ?? "",
    );

Map<String, dynamic> _$AddBlogModelToJson(AddBlogModel instance) =>
    <String, dynamic>{
      'coverImage': instance.coverImage,
      '_id': instance.id,
      'username': instance.username,
      'title': instance.title,
      'body': instance.body,
      'comment': instance.comment,
      'like': instance.like,
      'share': instance.share,
    };
