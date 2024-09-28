import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_news_example/landing/landing.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_news_example/terms_of_service/view/view.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:go_router/go_router.dart';

part 'app_router.g.dart';

class AppRouter {
  AppRouter({
    required AppBloc appBloc,
  }) {
    _goRouter = _routes(
      appBloc: appBloc,
    );
  }

  late final GoRouter _goRouter;

  GoRouter get goRouter => _goRouter;

  /// Only routes that are accessible to unauthenticated users
  final onlyUnauthenticatedUserRoutes = <String>[
    const LandingPageRoute().location,
    const LoginPageRoute().location,
    const LoginWithEmailPageRoute().location,
  ];

  // / Only routes that are accessible for authenticated users
  final onlyAuthenticatedUserRoutes = <String>[
    const HomePageRoute().location,
    const UserProfilePageRoute().location,
  ];

  GoRouter _routes({
    required AppBloc appBloc,
  }) {
    final appBlocListenable = AppBlocListenable(appBloc: appBloc);
    return GoRouter(
      initialLocation: const LandingPageRoute().location,
      refreshListenable: appBlocListenable,
      redirect: (context, state) {
        final path = state.uri.path;
        final isAuthenticated = appBloc.state.isAuthenticated;
        log('Going to path: $path, isAuthenticated: $isAuthenticated');
        if (onlyUnauthenticatedUserRoutes.contains(path) && isAuthenticated) {
          return const HomePageRoute().location;
        }
        if (onlyAuthenticatedUserRoutes.contains(path) && !isAuthenticated) {
          return const LandingPageRoute().location;
        }
        return null;
      },
      routes: $appRoutes,
    );
  }
}

@TypedGoRoute<LandingPageRoute>(
  name: 'landing',
  path: '/',
  routes: [
    TypedGoRoute<LoginPageRoute>(
      name: 'login',
      path: 'login',
      routes: [
        TypedGoRoute<LoginWithEmailPageRoute>(
          name: 'login-with-email',
          path: 'login-with-email',
        ),
      ],
    ),
  ],
)
class LandingPageRoute extends GoRouteData {
  const LandingPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LandingPage();
  }
}

@immutable
class LoginPageRoute extends GoRouteData {
  const LoginPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@immutable
class LoginWithEmailPageRoute extends GoRouteData {
  const LoginWithEmailPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginWithEmailPage();
  }
}

@TypedGoRoute<HomePageRoute>(
  name: 'home',
  path: '/home',
  routes: [
    TypedGoRoute<UserProfilePageRoute>(
      name: 'user-profile',
      path: 'user-profile',
      routes: [
        TypedGoRoute<TermsOfServicePageRoute>(
          name: 'terms-of-service',
          path: 'terms-of-service',
        ),
      ],
    ),
  ],
)
@immutable
class HomePageRoute extends GoRouteData {
  const HomePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

@immutable
class UserProfilePageRoute extends GoRouteData {
  const UserProfilePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserProfilePage();
  }
}

@immutable
class TermsOfServicePageRoute extends GoRouteData {
  const TermsOfServicePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TermsOfServicePage();
  }
}
