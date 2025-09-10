import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/constants/api_constants.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Email o contraseña incorrectos');
    }
  }
}