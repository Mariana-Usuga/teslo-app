import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';

class GoRouterNotifier extends ChangeNotifier {
  AuthStatus? _authStatus = AuthStatus.checking;
  AuthBloc? authBloc;

  GoRouterNotifier({this.authBloc});

  AuthStatus get authStatus => _authStatus!;

  //get authenticated => null;

  set authStatus(AuthStatus newAuthStatus) {
    print('entra en SET');
    _authStatus = newAuthStatus;
    notifyListeners();
  }

  bool get authenticated {
    return _authStatus == AuthStatus.authenticated;
  }
}

final authStatusNotifier = Provider((ref) {
  //final authBloc = AuthBloc(); // Obtén el AuthBloc
  return GoRouterNotifier();
});

//final authStatusNotifier = AuthStatusNotifier();

//final authBloc AuthBloc();

/*final authStatusNotifierProvider =
    ChangeNotifierProvider<AuthStatusNotifier>((ref) {
  return AuthStatusNotifier();
});*/


/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';

final authBlocProvider = Provider<AuthBloc>((ref) {
  return AuthBloc();
});

final goRouterNotifierProvider = Provider<GoRouterNotifier>((ref) {
  final authBloc = ref.read(authBlocProvider);

  return GoRouterNotifier(authBloc);
});

class GoRouterNotifier extends ChangeNotifier {
  final AuthBloc _authBloc;

  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier(this._authBloc) {
    print('entra en NOTIFIER');
    _authBloc.stream.listen((event) {
      authStatus = event.authStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }
}*/

