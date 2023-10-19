part of 'login_form_bloc.dart';

class LoginFormState extends Equatable {
  final bool isPosting; // operacion de envio
  final bool isFormPosted; //cuando se envia en form
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Email? email,
          Password? password}) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  String toString() {
    return ''' 
    LoginFormState:
    isPosting:$isPosting
    isFormPosted:$isFormPosted
    isValid:$isValid
    email:$email
    password:$password
    ''';
  }

  @override
  List<Object> get props => [isPosting, isFormPosted, isValid, email, password];
}
