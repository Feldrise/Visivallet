import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:visivallet/features/event/models/event/event.dart';

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
  }) = _Contact;

  factory Contact.fromJson(Map<String, Object?> json) => _$ContactFromJson(json);
}
