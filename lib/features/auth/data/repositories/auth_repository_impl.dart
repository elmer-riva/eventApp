import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/services/auth_manager.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/utils/resource.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/domain/entities/user_entity.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthManager authManager;

  AuthRepositoryImpl({required this.remoteDataSource, required this.authManager});

  @override
  Future<Resource<UserEntity>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await authManager.saveToken(user.token);
      return Success(user);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return authManager.getToken() != null;
  }

  @override
  Future<void> logout() async {
    await authManager.deleteToken();
  }
}