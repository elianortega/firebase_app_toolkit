import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:user_repository/user_repository.dart';

class LoginWithEmailPage extends StatelessWidget {
  const LoginWithEmailPage({super.key});

  static const String name = '/login-with-email';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
        ),
        body: const LoginWithEmailForm(),
      ),
    );
  }
}
