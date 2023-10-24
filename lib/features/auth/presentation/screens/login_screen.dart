import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/login_form_bloc/login_form_bloc.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../bloc/auth_bloc.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return //BlocProvider<LoginFormBloc>(
        //create: (_) => LoginFormBloc(loginUserCallback: createUpdateCallback),
        GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: GeometricalBackground(
                    child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      // Icon Banner
                      const Icon(
                        Icons.production_quantity_limits_rounded,
                        color: Colors.white,
                        size: 100,
                      ),
                      const SizedBox(height: 80),

                      Container(
                          height: size.height -
                              260, // 80 los dos sizebox y 100 el ícono
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(100)),
                          ),
                          child: _LoginForm())
                    ],
                  ),
                ))));
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormBlocProvider);
    final auth = ref.watch(authBlocProvider);

    /*ref.listen(authBlocProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });*/
    final scaffoldKey = ScaffoldMessenger.of(context);

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text('Login', style: textStyles.titleLarge),
          const SizedBox(height: 40),
          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            //onChanged: (value) => loginForm.add(OnEmailChange(email: value)),
            onChanged: ref.read(loginFormBlocProvider.notifier).onEmailChange,
            errorMessage:
                loginForm.isFormPosted ? loginForm.email.errorMessage : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged:
                ref.read(loginFormBlocProvider.notifier).onPasswordChanged,
            onFieldSubmitted: (_) =>
                ref.read(loginFormBlocProvider.notifier).onFormSubmit(),
            errorMessage:
                loginForm.isFormPosted ? loginForm.password.errorMessage : null,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomFilledButton(
              text: 'Ingresar',
              buttonColor: Colors.black,
              onPressed: () async {
                loginForm.isPosting
                    ? null
                    : ref.read(loginFormBlocProvider.notifier).onFormSubmit();

                if (auth.state.errorMessage != '') {
                  scaffoldKey.showSnackBar(SnackBar(
                    content: Text(
                      auth.state.errorMessage,
                      style: TextStyle(color: Colors.white),
                    ),
                  ));
                }
              },
            ),
          ),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                onPressed: () => context.push('/register'),
                child: const Text('Crea una aquí'),
              ),
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
/**
 * 
 *  BlocProvider(
      create: (context) => loginForm,
      child: BlocListener<LoginFormBloc, LoginFormState>(
         listener: (context, state) {

          Text('state email ${state.email}');
            if (auth.state.errorMessage != '') {
              // Se produjo un error al enviar el formulario, muestra un mensaje de error.
              scaffoldKey.showSnackBar(
                SnackBar(
                  content: Text(
                    auth.state.errorMessage,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          },
 */