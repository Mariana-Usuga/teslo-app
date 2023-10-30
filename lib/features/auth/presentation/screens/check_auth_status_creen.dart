import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teslo_shop/features/auth/presentation/bloc/auth_bloc.dart';

class CheckAuthStatusScreen extends StatefulWidget {
  const CheckAuthStatusScreen({super.key});

  @override
  State<CheckAuthStatusScreen> createState() => _CheckAuthStatusScreenState();
}

class _CheckAuthStatusScreenState extends State<CheckAuthStatusScreen> {
  late StreamSubscription authStream;

  @override
  void initState() {
    super.initState();
    //BlocProvider.of<AuthBloc>(context)..add(ChangeAuthStatus());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
