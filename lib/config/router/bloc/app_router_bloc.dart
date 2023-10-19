import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';

part 'app_router_event.dart';
part 'app_router_state.dart';

class AppRouterBloc extends Bloc<AppRouterEvent, AppRouterState> {
  final AuthBloc authBloc;
  AuthStatus _authStatus = AuthStatus.checking;
  //final _authStatusController = StreamController<AuthStatus>();

  AppRouterBloc(this.authBloc) : super(AppRouterState()) {
    /*authBloc.authStateController.stream.listen((status) {
      authStatus = status;
    };*/
    authBloc.stream.listen((event) {
      authStatus = event.authStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    //_authStatusController.add(value);
    //notifyListeners();
  }

  /*AppRouterBloc() : super(AppRouterState()) {
    on<AppRouterEvent>((event, emit) {
      // TODO: implement event handler
    });
  }*/
}
