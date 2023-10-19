part of 'login_form_bloc.dart';

class LoginFormEvent {
  const LoginFormEvent();
}

class OnEmailChange extends LoginFormEvent {
  final Email email;

  OnEmailChange(this.email);
}

class OnPasswordChange extends LoginFormEvent {
  final Password password;

  OnPasswordChange(this.password);
}
