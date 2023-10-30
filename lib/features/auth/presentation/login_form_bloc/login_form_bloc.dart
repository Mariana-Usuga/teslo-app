import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../bloc/auth_bloc.dart';

part 'login_form_event.dart';
part 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  //final Function(String, String) loginUserCallback;
  final AuthBloc authBloc;

  LoginFormBloc({required this.authBloc}) : super(LoginFormState()) {
    on<OnEmailChange>((event, emit) {
      final newEmail = Email.dirty(event.email);
      emit(state.copyWith(email: newEmail));
    });

    on<OnPasswordChange>((event, emit) {
      final newPassword = Password.dirty(event.password);
      emit(state.copyWith(password: newPassword));
    });

    on<FormSubmitted>((event, emit) async {
      print('entra en submit');

      _touchEveryField();

      if (!state.isValid) return;

      emit(state.copyWith(isPosting: true));

      authBloc.add(LoginUser(state.email.value, state.password.value));

      emit(state.copyWith(isPosting: false));
    });
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






/*import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

part 'login_form_event.dart';
part 'login_form_state.dart';

final loginFormBlocProvider = Provider<LoginFormBloc>((ref) {
  final createUpdateCallback = ref.watch(authBlocProvider).loginUser;

  return LoginFormBloc(
    loginUserCallback: createUpdateCallback,
  );
});

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final Function(String, String) loginUserCallback;

  LoginFormBloc({required this.loginUserCallback}) : super(LoginFormState()) {
    //on<OnEmailChange>(_onEmailChange);
    //on<OnPasswordChange>(_onPasswordChange);
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    emit(state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password])));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    emit(state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email])));
  }

  onFormSubmit() async {
    print('entra en submit ${state.password.errorMessage}');
    _touchEveryField();

    if (!state.isValid) return;

    emit(state.copyWith(isPosting: true));

    await loginUserCallback(state.email.value, state.password.value);

    emit(state.copyWith(isPosting: false));
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
}*/
