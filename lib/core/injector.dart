// Injector
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/authorization/service/auth_service.dart';
import '../features/auth/authorization/service/i_auth_service.dart';



GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register sharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => prefs);

   // Register AuthService
  locator.registerLazySingleton<IAuthService>(() => AuthService());
}
