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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
              height: size.height - 260, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: _LoginForm(),
            )
          ],
        ),
      ))),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = context.watch<LoginFormBloc>();
    final auth = context.watch<AuthBloc>();
    final scaffoldKey = ScaffoldMessenger.of(context);

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Login', style: textStyles.titleLarge),
          const SizedBox(height: 90),
          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            //onChanged: (value) => context.read<LoginFormBloc>().onEmailChange(value),
            onChanged: context.read<LoginFormBloc>().onEmailChange,
            errorMessage: loginForm.state.isFormPosted
                ? loginForm.state.email.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: context.read<LoginFormBloc>().onPasswordChange,
            errorMessage: loginForm.state.isFormPosted
                ? loginForm.state.password.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Ingresar',
                buttonColor: Colors.black,
                onPressed: () {
                  context.read<LoginFormBloc>().onFormSubmit();

                  if (auth.state.errorMessage != '') {
                    //print('contraseñas invalidas');
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
              )),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('Crea una aquí'))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
