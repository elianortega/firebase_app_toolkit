import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_news_example/navigation/navigation.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((HomeCubit cubit) => cubit.state.tabIndex);
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: AppLogo.dark(),
          centerTitle: true,
          actions: const [UserProfileButton()],
        ),
        drawer: const NavDrawer(),
        body: IndexedStack(
          index: selectedTab,
          children: const [
            Center(child: Text('Feed')),
            Center(child: Text('Search')),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: selectedTab,
          onTap: (value) {
            context.read<HomeCubit>().setTab(value);
          },
        ),
      ),
    );
  }
}
