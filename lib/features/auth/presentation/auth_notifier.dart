import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/entities/user.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    debugPrint('[AuthNotifier] FAKE AUTH: Usuario mockeado automáticamente');
    state = const AuthAuthenticated(User(
      id: 'mock-123',
      email: 'test@mock.com',
      firstName: 'Thomas',
      lastName: 'User',
      role: 'user',
    ));
  }

  Future<void> login(String email, String password) async {
    debugPrint('[AuthNotifier] FAKE LOGIN: Autenticación exitosa mockeada');
    state = const AuthAuthenticated(User(
      id: 'mock-123',
      email: 'test@mock.com',
      firstName: 'Mock',
      lastName: 'User',
      role: 'user',
    ));
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
  }) async {
    state = const AuthLoading();

    final result = await _registerUseCase(
      email: email,
      password: password,
      firstName: firstName,
    );

    result.fold(
      (failure) {
        debugPrint('[AuthNotifier] Register fallido: ${failure.message}');
        state = AuthError(failure.message);
      },
      (user) {
        debugPrint('[AuthNotifier] Register exitoso: ${user.email}');
        state = AuthAuthenticated(user);
      },
    );
  }

  Future<void> logout() async {
    await _logoutUseCase();
    state = const AuthUnauthenticated();
  }
}
