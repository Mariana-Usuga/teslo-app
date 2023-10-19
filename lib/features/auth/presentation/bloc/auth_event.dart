part of 'auth_bloc.dart';

class AuthEvent {
  const AuthEvent();
}

class LoginUser extends AuthEvent {
  final String email;
  final String password;

  LoginUser(this.email, this.password);
}

class RegisterUser extends AuthEvent {
  final String password;

  RegisterUser(this.password);
}

class ChangeAuthStatus extends AuthEvent {
  final AuthStatus newStatus;

  ChangeAuthStatus(this.newStatus);
}
