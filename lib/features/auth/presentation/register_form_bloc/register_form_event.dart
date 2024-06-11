part of 'register_form_bloc.dart';

class RegisterFormEvent {
  const RegisterFormEvent();
}

class OnEmailChange extends RegisterFormEvent {
  final String email;

  OnEmailChange(this.email);
}

class OnPasswordChange extends RegisterFormEvent {
  final String password;

  OnPasswordChange(this.password);
}

class OnFullNameChange extends RegisterFormEvent {
  final String fullName;

  OnFullNameChange(this.fullName);
}

class FormSubmitted extends RegisterFormEvent {
  FormSubmitted();
}
