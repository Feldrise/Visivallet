import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:visivallet/features/user/models/user_profile/user_profile.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    int? id,
    required String email,
    required String phone,
    UserProfile? profile,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
