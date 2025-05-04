import 'package:visivallet/features/company/database/data_sources/company_data_source.dart';
import 'package:visivallet/features/company/database/repositories/company_repository.dart';
import 'package:visivallet/features/company/models/company/company.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyDataSource _companyDataSource;

  CompanyRepositoryImpl(this._companyDataSource);

  @override
  Future<List<Company>> getAllCompanies() {
    return _companyDataSource.getAllCompanies();
  }

  @override
  Future<List<Company>> searchCompanies(String query) {
    return _companyDataSource.searchCompanies(query);
  }

  @override
  Future<Company?> getCompanyById(int id) {
    return _companyDataSource.getCompanyById(id);
  }

  @override
  Future<Company> createCompany(Company company) async {
    final id = await _companyDataSource.createCompany(company);
    return company.copyWith(id: id);
  }

  @override
  Future<int> updateCompany(Company company) {
    return _companyDataSource.updateCompany(company);
  }

  @override
  Future<int> deleteCompany(int id) {
    return _companyDataSource.deleteCompany(id);
  }
}
