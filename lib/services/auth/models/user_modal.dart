import 'package:json_annotation/json_annotation.dart';
part 'user_modal.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String name;
  final String email;
  final String profilePicture;
  final String? token;
  final String? uid;

  User({
    required this.name,
    required this.email,
    required this.profilePicture,
    this.token,
    this.uid,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  copywith({
    String? name,
    String? email,
    String? profilePicture,
    String? token,
    String? uid,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      token: token ?? this.token,
      uid: uid ?? this.uid,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ErrorModel {
  final String? error;
  final dynamic data;

  ErrorModel({this.error, this.data});

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
