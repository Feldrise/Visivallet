import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/features/company/database/data_sources/company_data_source.dart';
import 'package:visivallet/features/company/database/repositories/company_repository.dart';
import 'package:visivallet/features/company/database/repositories/company_repository_impl.dart';
import 'package:visivallet/features/company/models/company/company.dart';

final companyDataSourceProvider = Provider<CompanyDataSource>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  return CompanyDataSource(appDatabase);
});

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final companyDataSource = ref.watch(companyDataSourceProvider);
  return CompanyRepositoryImpl(companyDataSource);
});

final companiesProvider = FutureProvider<List<Company>>((ref) async {
  final companyRepository = ref.watch(companyRepositoryProvider);
  return companyRepository.getAllCompanies();
});

final companySearchProvider = FutureProvider.family<List<Company>, String>((ref, query) async {
  final companyRepository = ref.watch(companyRepositoryProvider);
  return companyRepository.searchCompanies(query);
});

final companyByIdProvider = FutureProvider.family<Company?, int>((ref, id) async {
  final companyRepository = ref.watch(companyRepositoryProvider);
  return companyRepository.getCompanyById(id);
});
