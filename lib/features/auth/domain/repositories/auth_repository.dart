import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/utils/resource.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Resource<UserEntity>> login(String email, String password);
  Future<bool> isAuthenticated();
  Future<void> logout();
}