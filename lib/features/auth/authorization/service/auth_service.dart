// Auth service
import 'package:dio/dio.dart';

import '../model/i_user.dart';
import '../model/user.dart';
import 'i_auth_service.dart';

class AuthService implements IAuthService {
  final Dio _dio = Dio();

  @override
  Future<IUser> login(String email, String password) async {
    final response = await _dio.get('https://randomuser.me/api/');
    if (response.statusCode == 200) {
      return User.fromJson(response.data['results'][0]);
    } else {
      User(email: '', name: '', imageUrl: '');
      throw Exception('Failed to load user');
    }
  }
}