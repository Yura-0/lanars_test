// Auth service abstraction
import '../model/i_user.dart';

abstract class IAuthService {
  Future<IUser> login(String email, String password);
}
