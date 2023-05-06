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
}
