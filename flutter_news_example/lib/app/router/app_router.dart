import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_news_example/terms_of_service/view/view.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  /// Only routes that are accessible to unauthenticated users
  static const onlyUnauthenticatedUserRoutes = <String>[
    LoginWithEmailPage.name,
  ];

  /// Only routes that are accessible for authenticated users
  static const onlyAuthenticatedUserRoutes = <String>[
    HomePage.name,
    UserProfilePage.name,
  ];

  static GoRouter router({
    required AppBloc appBloc,
  }) {
    final appBlocListenable = AppBlocListenable(appBloc);
    return GoRouter(
      initialLocation: HomePage.name,
      refreshListenable: appBlocListenable,
      redirect: (context, state) {
        final path = state.uri.path;
        final isAuthenticated = appBloc.state.isAuthenticated;
        if (onlyUnauthenticatedUserRoutes.contains(path) && isAuthenticated) {
          return HomePage.name;
        }
        if (onlyAuthenticatedUserRoutes.contains(path) && !isAuthenticated) {
          return LoginWithEmailPage.name;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: HomePage.name,
          pageBuilder: (context, state) => HomePage.page(),
        ),
        GoRoute(
          path: LoginWithEmailPage.name,
          pageBuilder: (context, state) => LoginWithEmailPage.route(),
        ),
        GoRoute(
          path: TermsOfServicePage.name,
          pageBuilder: (context, state) => TermsOfServicePage.route(),
        ),
        GoRoute(
          path: UserProfilePage.name,
          pageBuilder: (context, state) => UserProfilePage.route(),
        ),
      ],
    );
  }
}
