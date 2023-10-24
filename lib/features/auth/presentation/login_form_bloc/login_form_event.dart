part of 'login_form_bloc.dart';

class LoginFormEvent {
  const LoginFormEvent();
}

class OnEmailChange extends LoginFormEvent {
  final String email;

  OnEmailChange({required this.email});
}

class OnPasswordChange extends LoginFormEvent {
  final String password;

  OnPasswordChange({required this.password});
}

class FormSubmitted extends LoginFormEvent {
  FormSubmitted();
}
