part of 'register_form_bloc.dart';

class RegisterFormState /*extends Equatable*/ {
  final bool isPosting; // operacion de envio
  final bool isFormPosted; //cuando se envia en form
  final bool isValid;
  final Email email;
  final Password password;
  final FullName fullName;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.fullName = const FullName.pure(),
  });

  RegisterFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Email? email,
          Password? password,
          FullName? fullName}) =>
      RegisterFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password,
          fullName: fullName ?? this.fullName);

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

  //@override
  //List<Object> get props => [isPosting, isFormPosted, isValid, email, password];
}
