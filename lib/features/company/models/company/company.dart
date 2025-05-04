import 'package:freezed_annotation/freezed_annotation.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
abstract class Company with _$Company {
  Company._();

  factory Company({
    int? id,
    required String name,
    String? siret,
    String? description,
  }) = _Company;

  factory Company.fromJson(Map<String, Object?> json) => _$CompanyFromJson(json);
}
