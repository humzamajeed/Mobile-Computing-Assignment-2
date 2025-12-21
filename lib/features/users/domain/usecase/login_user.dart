import '../entities/user.dart';
import '../repository/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<User> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
