import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../model/user_model.dart';
import '../source/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String username, String password) async {
    final UserModel user = await remoteDataSource.login(username, password);

    return User(
      id: user.id,
      username: user.username,
      email: user.email,
      token: user.token,
    );
  }
}
