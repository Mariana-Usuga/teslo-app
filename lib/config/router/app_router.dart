import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teslo_shop/features/products/products.dart';

final _publicRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => CheckAuthStatusScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => ProductsScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/product/:id', // /product/new
      builder: (context, state) => ProductScreen(
        productId: state.params['id'] ?? 'no-id',
      ),
    ),
  ],
);

class RouterSimpleCubit extends Cubit<GoRouter> {
  final AuthBloc authBloc;

  RouterSimpleCubit(this.authBloc) : super(_publicRouter);

  void checkAuthStatusAndRedirect(
    BuildContext context,
  ) async {
    final completer = Completer<void>();

    authBloc.add(ChangeAuthStatus());

    //authBloc.stream.listen((authStats) {
    //final authStatus = authState.authStatus;

    return completer.future;
  }

  void goProductsScreen() {
    state.go('/');
  }

  void goLogin() {
    state.go('/login');
  }
}
