import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router.dart';
//import 'package:teslo_shop/config/router/app_router.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

import 'config/theme/app_theme.dart';
import 'features/auth/presentation/login_form_bloc/login_form_bloc.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/shared/infrastructure/services/key_value_storage_service_impl.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  final keyValueStorageService = KeyValueStorageServiceImpl();
  final token = await keyValueStorageService.getValue<String>('token');

  final authRepository = AuthRepositoryImpl();
  final productsRepository =
      ProductsRepositoryImpl(ProductsDatastoreImpl(accessToken: token));

  final authBloc = AuthBloc(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);

  //final productsBloc =
  //  ProductsBloc(productsRepository: ProductsRepositoryImpl());

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginFormBloc>(
              create: (context) => LoginFormBloc(authBloc: authBloc)),
          BlocProvider<AuthBloc>(create: (context) => authBloc),
          BlocProvider<RouterSimpleCubit>(
              create: (context) => RouterSimpleCubit(authBloc)),
          BlocProvider<ProductsBloc>(
              create: (context) =>
                  ProductsBloc(productsRepository: productsRepository)),
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
    final appRouter = context.watch<RouterSimpleCubit>().state;
    final routerCubit = context.read<RouterSimpleCubit>();

    //BlocProvider.of<AuthBloc>(context)..add(ChangeAuthStatus());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      routerCubit.checkAuthStatusAndRedirect(context);
    });

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState.authStatus == AuthStatus.checking) {
          print('entra en checking');
          return null;
        }
        if (authState.authStatus == AuthStatus.notAuthenticated) {
          print('entra en login');
          appRouter.go('/login');
        }
        if (authState.authStatus == AuthStatus.authenticated) {
          appRouter.go('/');
        }
      },
      child: MaterialApp.router(
        routerConfig: appRouter,
        theme: AppTheme().getTheme(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
