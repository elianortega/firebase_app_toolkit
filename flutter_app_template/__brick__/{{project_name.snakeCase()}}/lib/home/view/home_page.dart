import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
      ],
      child: const HomeView(),
    );
  }
}
