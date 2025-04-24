// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhoneContactImpl _$$PhoneContactImplFromJson(Map<String, dynamic> json) =>
    _$PhoneContactImpl(
      json['id'],
      displayName: json['displayName'],
      photo: json['photo'],
      thumbnail: json['thumbnail'],
      name: json['name'],
      phones: (json['phones'] as List<dynamic>?)
              ?.map((e) => Phone.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Phone>[],
      emails: (json['emails'] as List<dynamic>?)
              ?.map((e) => Email.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Email>[],
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Address>[],
      organizations: (json['organizations'] as List<dynamic>?)
              ?.map((e) => Organization.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Organization>[],
      websites: (json['websites'] as List<dynamic>?)
              ?.map((e) => Website.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Website>[],
      socialMedias: (json['socialMedias'] as List<dynamic>?)
              ?.map((e) => SocialMedia.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SocialMedia>[],
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Event>[],
      notes: (json['notes'] as List<dynamic>?)
              ?.map((e) => Note.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Note>[],
      groups: (json['groups'] as List<dynamic>?)
              ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Group>[],
    );

Map<String, dynamic> _$$PhoneContactImplToJson(_$PhoneContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'photo': instance.photo,
      'thumbnail': instance.thumbnail,
      'name': instance.name,
      'phones': instance.phones,
      'emails': instance.emails,
      'addresses': instance.addresses,
      'organizations': instance.organizations,
      'websites': instance.websites,
      'socialMedias': instance.socialMedias,
      'events': instance.events,
      'notes': instance.notes,
      'groups': instance.groups,
    };
