import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

part 'login_form_event.dart';
part 'login_form_state.dart';

/*final authBlocProvider = Provider<AuthBloc>((ref) {
  return AuthBloc();
});*/
final authBloc = AuthBloc();

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final AuthBloc authBloc;
  //final loginUser = authBloc.loginUser;

  LoginFormBloc({required this.authBloc}) : super(LoginFormState()) {
    on<OnEmailChange>(_onEmailChange);
    on<OnPasswordChange>(_onPasswordChange);
  }

  void _onEmailChange(OnEmailChange event, Emitter<LoginFormState> emit) {
    //final newEmail = Email.dirty(event.email.toString());
    emit(state.copyWith(
        email: event.email,
        isValid: Formz.validate([event.email, state.password])));
  }

  void _onPasswordChange(OnPasswordChange event, Emitter<LoginFormState> emit) {
    //final newPassword = Password.dirty(event.password.toString());
    emit(state.copyWith(
        password: event.password,
        isValid: Formz.validate([event.password, state.email])));
  }

  void onEmailChange(value) {
    final newEmail = Email.dirty(value);
    add(OnEmailChange(newEmail));
  }

  void onPasswordChange(value) {
    final newPassword = Password.dirty(value);
    add(OnPasswordChange(newPassword));
  }

  void onFormSubmit() async {
    print('entra en formSubmit');
    await _touchEveryField();

    if (!state.isValid) return;

    //emit(state.copyWith(isPosting: true));

    /*final authBlocProvider = Provider((ref) {
      return AuthBloc();
    });
    final container = ProviderContainer();
    final authBloc = container.read(authBlocProvider);*/

    await authBloc.loginUser(state.email.value, state.password.value);

    //emit(state.copyWith(isPosting: false));
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    emit(state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password])));
  }
}
