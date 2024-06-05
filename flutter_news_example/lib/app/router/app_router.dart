import 'package:flutter/material.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_news_example/landing/view/landing_page.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_news_example/terms_of_service/view/view.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  /// Only routes that are accessible to unauthenticated users
  static const onlyUnauthenticatedUserRoutes = <String>[
    LandingPage.path,
    LoginPage.path,
    LoginWithEmailPage.name,
  ];

  /// Only routes that are accessible for authenticated users
  static const onlyAuthenticatedUserRoutes = <String>[
    HomePage.path,
    UserProfilePage.path,
  ];

  static GoRouter router({
    required AppBloc appBloc,
  }) {
    final appBlocListenable = AppBlocListenable(appBloc);
    return GoRouter(
      initialLocation: LandingPage.path,
      refreshListenable: appBlocListenable,
      redirect: (context, state) {
        final path = state.uri.path;
        final isAuthenticated = appBloc.state.isAuthenticated;
        if (onlyUnauthenticatedUserRoutes.contains(path) && isAuthenticated) {
          return HomePage.path;
        }
        if (onlyAuthenticatedUserRoutes.contains(path) && !isAuthenticated) {
          return LandingPage.path;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: LandingPage.path,
          name: LandingPage.path,
          pageBuilder: (context, state) => const MaterialPage<void>(
            child: LandingPage(),
          ),
        ),
        GoRoute(
          path: LoginPage.path,
          name: LoginPage.path,
          pageBuilder: (context, state) =>
              const MaterialPage<void>(child: LoginPage()),
        ),
        GoRoute(
          path: LoginWithEmailPage.name,
          name: LoginWithEmailPage.name,
          pageBuilder: (context, state) => const MaterialPage<void>(
            child: LoginWithEmailPage(),
          ),
        ),
        GoRoute(
          path: HomePage.path,
          name: HomePage.path,
          pageBuilder: (context, state) => const MaterialPage<void>(
            child: HomePage(),
          ),
        ),
        GoRoute(
          path: TermsOfServicePage.path,
          name: TermsOfServicePage.path,
          pageBuilder: (context, state) => const MaterialPage<void>(
            child: TermsOfServicePage(),
          ),
        ),
        GoRoute(
          path: UserProfilePage.path,
          name: UserProfilePage.path,
          pageBuilder: (context, state) => const MaterialPage<void>(
            child: UserProfilePage(),
          ),
        ),
      ],
    );
  }
}
