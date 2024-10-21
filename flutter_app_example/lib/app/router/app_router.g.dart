// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $landingPageRoute,
      $homePageRoute,
    ];

RouteBase get $landingPageRoute => GoRouteData.$route(
      path: '/',
      name: 'landing',
      factory: $LandingPageRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'login',
          name: 'login',
          factory: $LoginPageRouteExtension._fromState,
        ),
      ],
    );

extension $LandingPageRouteExtension on LandingPageRoute {
  static LandingPageRoute _fromState(GoRouterState state) =>
      const LandingPageRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LoginPageRouteExtension on LoginPageRoute {
  static LoginPageRoute _fromState(GoRouterState state) =>
      const LoginPageRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homePageRoute => GoRouteData.$route(
      path: '/home',
      name: 'home',
      factory: $HomePageRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'user-profile',
          name: 'user-profile',
          factory: $UserProfilePageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'terms-of-service',
              name: 'terms-of-service',
              factory: $TermsOfServicePageRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $HomePageRouteExtension on HomePageRoute {
  static HomePageRoute _fromState(GoRouterState state) => const HomePageRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UserProfilePageRouteExtension on UserProfilePageRoute {
  static UserProfilePageRoute _fromState(GoRouterState state) =>
      const UserProfilePageRoute();

  String get location => GoRouteData.$location(
        '/home/user-profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TermsOfServicePageRouteExtension on TermsOfServicePageRoute {
  static TermsOfServicePageRoute _fromState(GoRouterState state) =>
      const TermsOfServicePageRoute();

  String get location => GoRouteData.$location(
        '/home/user-profile/terms-of-service',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
