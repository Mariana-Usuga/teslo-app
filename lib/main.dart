import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/config/router/app_router.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';

import 'config/theme/app_theme.dart';
import 'features/products/infrastructure/infrastructure.dart';
import 'features/products/presentation/repo.dart';

//se va al main cuando inicia
void main() async {
  await dotenv.load(fileName: '.env');

  //await Environment.initEnvironment();
  //final repo = ProductsRepositoryImpl(ProductsDatastoreImpl(accessToken: ''));
  runApp(
    const ProviderScope(child: MainApp()),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
