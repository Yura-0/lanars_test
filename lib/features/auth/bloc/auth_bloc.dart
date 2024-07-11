import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authorization/model/i_user.dart';
import '../authorization/model/user.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences _prefs;

  AuthBloc(this._prefs) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final loggedIn = _prefs.getBool('loggedIn') ?? false;
    if (loggedIn) {
      final user = _getUserFromPrefs();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await Dio().get('https://randomuser.me/api/');
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data['results'][0]);
        if (user.email.isNotEmpty && user.name.isNotEmpty && user.imageUrl.isNotEmpty) {
          await _saveUserToPrefs(user);
          await _prefs.setBool('loggedIn', true);
          emit(AuthSuccess(user));
        } else {
          emit(AuthFailure('Invalid user data'));
        }
      } else {
        emit(AuthFailure('Failed to login'));
      }
    } catch (e) {
      emit(AuthFailure('Network error: $e'));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _prefs.clear();
    emit(AuthInitial());
  }

  IUser? _getUserFromPrefs() {
    final name = _prefs.getString('name');
    final email = _prefs.getString('email');
    final imageUrl = _prefs.getString('imageUrl');

    if (name != null && email != null && imageUrl != null) {
      return User(name: name, email: email, imageUrl: imageUrl);
    }
    return null;
  }

  Future<void> _saveUserToPrefs(IUser user) async {
    await _prefs.setString('name', user.name);
    await _prefs.setString('email', user.email);
    await _prefs.setString('imageUrl', user.imageUrl);
  }
}