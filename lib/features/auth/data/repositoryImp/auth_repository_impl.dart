import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../model/user_model.dart';
import '../source/auth_remote_datasources.dart';  // ✅ FIXED IMPORT

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String username, String password) async {
    // ✅ Data source returns UserModel (extends User)
    final UserModel userModel = await remoteDataSource.login(username, password);

    return userModel;  // ✅ No need to manually map again
  }
}
