// Injector
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/bloc/auth_bloc.dart';
import '../features/home/bloc/photo_bloc.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register sharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => prefs);

  // Register blocs
  locator.registerLazySingleton<AuthBloc>(() => AuthBloc(prefs));

  locator.registerLazySingleton<PhotoBloc>(() => PhotoBloc());
}
