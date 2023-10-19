import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository_impl.dart';

import '../../../shared/infrastructure/inputs/services/key_value_storage_service_impl.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepository = AuthRepositoryImpl(); //NO SE DONDE VA
  final keyValueStorageService = KeyValueStorageServiceImpl();

  AuthBloc() : super(AuthState()) {
    checkAuthStatus();
    //on<LoginUser>(_loginUser);
  }

  /*void _loginUser(LoginUser event, Emitter<AuthState> emit) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(event.email, event.password);
      await keyValueStorageService.setKeyValue('token', user.token);

      emit(state.copyWith(
        user: user,
        authStatus: AuthStatus.authenticated,
        errorMessage: '',
      ));
      //emit(newState);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }*/

  void _registerUser(RegisterUser event, Emitter<AuthState> emit) {
    //final newEmail = Email.dirty(event.email.toString());
    emit(state.copyWith());
  }

  void checkAuthStatus() async {
    print('ENTRA EN CHECK');

    final token = await keyValueStorageService.getValue<String>('token');

    if (token == null) return logout();

    try {
      //print('entra en hay token');
      final user = await authRepository.checkAuthStatus(token);

      await keyValueStorageService.setKeyValue('token', user.token);

      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(User user) async {
    // TODO: necesito guardar el token físicamente
    final a = user.email;
    print('USER en _setLoggedUser $a');

    await keyValueStorageService.setKeyValue('token', user.token);
    //authBloc.add(ChangeAuthStatus(AuthStatus.authenticated));

    emit(state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    ));
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('entra en loginUser despues del delayes');

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado!!');
    }
  }

  Future<void> logout([String? errorMessage]) async {
    //print('ENTRA EN LOGOUT $errorMessage');
    await keyValueStorageService.removeKey('token');

    emit(state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    ));

    //final authStatusNotifier = AuthStatusNotifier();
    //authStatusNotifier.authStatus = AuthStatus.authenticated;
  }
}
/**   
 *  Future<void> loginUser(String email, String password) async {
    //_log(String email, String password);

    await Future.delayed(const Duration(milliseconds: 500));
    print('entra en loginUser despues del delayes');
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }
 */