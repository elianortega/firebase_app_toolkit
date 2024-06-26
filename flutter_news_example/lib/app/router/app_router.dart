import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_news_example/landing/landing.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_news_example/terms_of_service/view/view.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingjay/mockingjay.dart';

class AppRouter {
  /// Only routes that are accessible to unauthenticated users
  static const onlyUnauthenticatedUserRoutes = <String>[
    LandingPage.path,
    LoginPage.path,
    LoginWithEmailPage.path,
  ];

  /// Only routes that are accessible for authenticated users
  static const onlyAuthenticatedUserRoutes = <String>[
    HomePage.path,
    UserProfilePage.path,
  ];

  @visibleForTesting
  static final routes = [
    GoRoute(
      path: LandingPage.path,
      name: LandingPage.path,
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: LoginPage.path,
      name: LoginPage.path,
      builder: (context, state) => SignInScreen(
        auth: Platform.environment.containsKey('FLUTTER_TEST')
            ? MockAuth()
            : null,
        providers: [
          EmailAuthProvider(),
          // TODO(any): add client id to enable desktop login
          GoogleProvider(clientId: ''),
        ],
      ),
    ),
    GoRoute(
      path: LoginWithEmailPage.path,
      name: LoginWithEmailPage.path,
      builder: (context, state) => const LoginWithEmailPage(),
    ),
    GoRoute(
      path: HomePage.path,
      name: HomePage.path,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: TermsOfServicePage.path,
      name: TermsOfServicePage.path,
      builder: (context, state) => const TermsOfServicePage(),
    ),
    GoRoute(
      path: UserProfilePage.path,
      name: UserProfilePage.path,
      builder: (context, state) => const UserProfilePage(),
    ),
  ];

  static GoRouter router({
    required AppBloc appBloc,
  }) {
    final appBlocListenable = AppBlocListenable(appBloc: appBloc);
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
      routes: routes,
    );
  }
}

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockAuth extends Mock implements fba.FirebaseAuth {
  @override
  FirebaseApp get app => MockFirebaseApp();
}
