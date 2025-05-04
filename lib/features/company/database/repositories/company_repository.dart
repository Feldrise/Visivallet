import 'package:visivallet/features/company/models/company/company.dart';

abstract class CompanyRepository {
  Future<List<Company>> getAllCompanies();
  Future<List<Company>> searchCompanies(String query);
  Future<Company?> getCompanyById(int id);
  Future<Company> createCompany(Company company);
  Future<int> updateCompany(Company company);
  Future<int> deleteCompany(int id);
}
