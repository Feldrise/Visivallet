import 'package:visivallet/features/user/models/user/user.dart';

abstract class UserRepository {
  // User operations
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(int id);
}
