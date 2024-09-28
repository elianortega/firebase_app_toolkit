import 'package:bloc_test/bloc_test.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/home/home.dart';
import 'package:{{project_name.snakeCase()}}/landing/landing.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:{{project_name.snakeCase()}}/terms_of_service/terms_of_service.dart';
import 'package:{{project_name.snakeCase()}}/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends Mock implements AppBloc {}

class MockAppBlocListenable extends Mock implements AppBlocListenable {}

void main() {
  group('AppRouter', () {
    group('renders', () {
      GoRouter buildRouter(String initialLocation) => GoRouter(
            initialLocation: initialLocation,
            routes: $appRoutes,
          );

      final pages = {
        const LandingPageRoute().location: LandingPage,
        const LoginPageRoute().location: LoginPage,
        const LoginWithEmailPageRoute().location: LoginWithEmailPage,
        const HomePageRoute().location: HomePage,
        const UserProfilePageRoute().location: UserProfilePage,
        const TermsOfServicePageRoute().location: TermsOfServicePage,
      };
      final keys = pages.keys.toList();
      for (final path in keys) {
        final page = pages[path]!;
        testWidgets(
          'renders $page when initialLocation is $path',
          (WidgetTester tester) async {
            await tester.pumpAppRouter(
              router: buildRouter(path),
            );

            expect(find.byType(page), findsOneWidget);
          },
        );
      }
    });

    group('redirect', () {
      testWidgets('to LandingPageRoute if user is not authenticated',
          (WidgetTester tester) async {
        final appBloc = MockAppBloc();
        whenListen(
          appBloc,
          Stream<AppState>.fromIterable(
            [const AppState.unauthenticated()],
          ),
          initialState: const AppState.authenticated(User(id: 'id')),
        );

        final appRouter = AppRouter(
          appBloc: appBloc,
          initialLocation: const HomePageRoute().location,
        );

        await tester.pumpAppRouter(
          router: appRouter.goRouter,
        );

        expect(find.byType(LandingPage), findsOneWidget);
      });
    });
  });
}
