import 'dart:io';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
abstract class Contact with _$Contact {
  Contact._();

  factory Contact({
    @override int? id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    int? companyId,
    String? imageBase64,
  }) = _Contact;

  factory Contact.fromJson(Map<String, Object?> json) => _$ContactFromJson(json);

  String get displayName => "$firstName $lastName";

  Future<Uint8List?> getImage() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory contactsDir = Directory('${directory.path}/contacts');
    final String filename = 'contact_${id ?? 0}.png';

    final File file = File('${contactsDir.path}/$filename');

    if (await file.exists()) {
      return await file.readAsBytes();
    }

    return null;
  }
}
