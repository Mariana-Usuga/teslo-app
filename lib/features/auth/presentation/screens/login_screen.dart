import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/login_form_bloc/login_form_bloc.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../bloc/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final loginFormBloc = context.read<LoginFormBloc>();
    final scaffoldKey = ScaffoldMessenger.of(context);

    return BlocListener<AuthBloc, AuthState>(listener: (context, state) {
      if (state.errorMessage != '') {
        scaffoldKey.showSnackBar(SnackBar(
          content: Text(
            state.errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        ));
      }
    }, child:
        BlocBuilder<LoginFormBloc, LoginFormState>(builder: (context, state) {
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
              onChanged: (value) => loginFormBloc.add(OnEmailChange(value)),
              errorMessage: loginFormBloc.state.isFormPosted
                  ? loginFormBloc.state.email.errorMessage
                  : null,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Contraseña',
              obscureText: true,
              onChanged: (value) => loginFormBloc.add(OnPasswordChange(value)),
              onFieldSubmitted: (_) => loginFormBloc.add(FormSubmitted()),
              errorMessage: loginFormBloc.state.isFormPosted
                  ? loginFormBloc.state.password.errorMessage
                  : null,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomFilledButton(
                text: 'Ingresar',
                buttonColor: Colors.black,
                onPressed: () async {
                  if (!loginFormBloc.state.isPosting) {
                    loginFormBloc.add(FormSubmitted());
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
    }));
  }
}

/**
 * 
 * 
if (authBloc.state.errorMessage != '') {
                    scaffoldKey.showSnackBar(SnackBar(
                      content: Text(
                        authBloc.state.errorMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  }

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