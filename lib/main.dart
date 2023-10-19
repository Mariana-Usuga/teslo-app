import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/config/router/app_router.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teslo_shop/features/auth/presentation/login_form_bloc/login_form_bloc.dart';

import 'config/theme/app_theme.dart';

//se va al main cuando inicia
void main() async {
  final authBloc = AuthBloc();
  await dotenv.load(fileName: '.env');

  //await Environment.initEnvironment();

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: authBloc,
          ),
          BlocProvider(
            create: (context) => LoginFormBloc(authBloc: authBloc),
            //create: (context) =>t
            //  LoginFormBloc(authBloc: context.read<AuthBloc>()),
          ),
        ],
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
