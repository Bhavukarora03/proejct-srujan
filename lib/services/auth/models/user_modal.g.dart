// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      email: json['email'] as String,
      profilePicture: json['profile_picture'] as String,
      token: json['token'] as String?,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'profile_picture': instance.profilePicture,
      'token': instance.token,
      'uid': instance.uid,
    };
