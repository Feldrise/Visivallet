import 'dart:io';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  UserProfile._();

  factory UserProfile({
    int? id,
    required int userId,
    required String firstName,
    required String lastName,
    String? imageBase64,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, Object?> json) => _$UserProfileFromJson(json);

  Future<Uint8List?> getImage() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filename = 'profile_${userId ?? 0}.png';

    final File file = File('${directory.path}/$filename');

    if (await file.exists()) {
      return await file.readAsBytes();
    }

    return null;
  }
}
