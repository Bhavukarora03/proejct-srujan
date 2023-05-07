// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_modal.dart';

// ****************r**********************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      email: json['email'] as String,
      profilePicture: json['profile_picture'] as String,
      token: json['token'] as String?,
      uid: json['_id'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'profile_picture': instance.profilePicture,
      'token': instance.token,
      '_id': instance.uid,
    };

ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) => ErrorModel(
      error: json['error'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$ErrorModelToJson(ErrorModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'data': instance.data,
    };
