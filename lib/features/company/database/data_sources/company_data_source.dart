import 'package:visivallet/core/database/app_database.dart';
import 'package:visivallet/features/company/database/tables/company_table.dart';
import 'package:visivallet/features/company/models/company/company.dart';

class CompanyDataSource {
  final AppDatabase _db;

  CompanyDataSource(this._db);

  Future<List<Company>> getAllCompanies() async {
    final maps = await _db.query(CompanyTable.tableName, orderBy: '${CompanyTable.columnName} ASC');
    return maps.map(CompanyTable.fromMap).toList();
  }

  Future<List<Company>> searchCompanies(String query) async {
    final maps = await _db.query(
      CompanyTable.tableName,
      where: '${CompanyTable.columnName} LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '${CompanyTable.columnName} ASC',
    );
    return maps.map(CompanyTable.fromMap).toList();
  }

  Future<Company?> getCompanyById(int id) async {
    final maps = await _db.query(
      CompanyTable.tableName,
      where: '${CompanyTable.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return CompanyTable.fromMap(maps.first);
  }

  Future<int> createCompany(Company company) async {
    return await _db.insert(
      CompanyTable.tableName,
      CompanyTable.toMap(company),
    );
  }

  Future<int> updateCompany(Company company) async {
    if (company.id == null) {
      throw Exception("Cannot update a company without an ID");
    }

    return await _db.update(
      CompanyTable.tableName,
      CompanyTable.toMap(company),
      where: '${CompanyTable.columnId} = ?',
      whereArgs: [company.id],
    );
  }

  Future<int> deleteCompany(int id) async {
    return await _db.delete(
      CompanyTable.tableName,
      where: '${CompanyTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
