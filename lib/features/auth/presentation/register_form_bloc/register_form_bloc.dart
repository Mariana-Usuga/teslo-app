import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/auth/auth_bloc.dart';
import 'package:teslo_shop/features/shared/shared.dart';

part 'register_form_event.dart';
part 'register_form_state.dart';

class RegisterFormBloc extends Bloc<RegisterFormEvent, RegisterFormState> {
  final AuthBloc authBloc;

  RegisterFormBloc({required this.authBloc}) : super(RegisterFormState()) {
    on<OnFullNameChange>((event, emit) {
      final newFullName = FullName.dirty(event.fullName);
      emit(state.copyWith(fullName: newFullName));
    });

    on<OnEmailChange>((event, emit) {
      final newEmail = Email.dirty(event.email);
      emit(state.copyWith(email: newEmail));
    });

    on<OnPasswordChange>((event, emit) {
      final newPassword = Password.dirty(event.password);
      emit(state.copyWith(password: newPassword));
    });

    on<RegisterFormEvent>((event, emit) async {
      _touchEveryField();

      if (!state.isValid) return;

      emit(state.copyWith(isPosting: true));

      authBloc.add(RegisterUser(
          state.email.value, state.fullName.value, state.password.value));

      emit(state.copyWith(isPosting: false));
    });
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullName = FullName.dirty(state.fullName.value);

    emit(state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        fullName: fullName,
        isValid: Formz.validate([email, password, fullName])));
  }
}
