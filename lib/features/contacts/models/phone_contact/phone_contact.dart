import 'dart:typed_data';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_contact.freezed.dart';
part 'phone_contact.g.dart';

@freezed
class PhoneContact with _$PhoneContact {
  const factory PhoneContact(
    String id, {
    required String displayName,
    Uint8List? photo,
    Uint8List? thumbnail,
    required Name name,
    @Default(<Phone>[]) List<Phone> phones,
    @Default(<Email>[]) List<Email> emails,
    @Default(<Address>[]) List<Address> addresses,
    @Default(<Organization>[]) List<Organization> organizations,
    @Default(<Website>[]) List<Website> websites,
    @Default(<SocialMedia>[]) List<SocialMedia> socialMedias,
    @Default(<Event>[]) List<Event> events,
    @Default(<Note>[]) List<Note> notes,
    @Default(<Group>[]) List<Group> groups,
  }) = _PhoneContact;

  factory PhoneContact.fromJson(Map<String, Object?> json) => _$PhoneContactFromJson(json);
}
