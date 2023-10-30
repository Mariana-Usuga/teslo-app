import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

import '../../../shared/infrastructure/services/key_value_storage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/*final authBlocProvider = Provider<AuthBloc>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthBloc(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});*/

//final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //final authRepository = AuthRepositoryImpl(); //NO SE DONDE VA
  final KeyValueStorageService keyValueStorageService;
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository, required this.keyValueStorageService})
      : super(AuthState()) {
    on<LoginUser>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 500));
      print('entra en loginUser despues del delayes');

      try {
        final user = await authRepository.login(event.email, event.password);
        _setLoggedUser(user);
      } on CustomError catch (e) {
        add(LogoutUser(errorMessage: e.message));
      } catch (e) {
        add(LogoutUser(errorMessage: 'Error no controlado!!'));
      }
    });

    on<ChangeAuthStatus>((event, emit) async {
      print('entra en la funcion ChangeAuthStatus');
      final token = await keyValueStorageService.getValue<String>('token');

      if (token == null) return add(LogoutUser());

      try {
        final user = await authRepository.checkAuthStatus(token);

        await keyValueStorageService.setKeyValue('token', user.token);

        emit(state.copyWith(
          user: user,
          authStatus: AuthStatus.authenticated,
          errorMessage: '',
        ));
      } catch (e) {
        add(LogoutUser());
      }
    });

    on<LogoutUser>((event, emit) async {
      await keyValueStorageService.removeKey('token');

      emit(state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: event.errorMessage,
      ));
    });

    on<RegisterUser>((event, emit) async {});
  }

  _setLoggedUser(User user) async {
    print('entra en _setLoggedUser');
    await keyValueStorageService.setKeyValue('token', user.token);

    emit(state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    ));
  }
}
