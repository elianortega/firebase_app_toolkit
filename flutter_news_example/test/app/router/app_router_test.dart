import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_news_example/landing/landing.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_news_example/terms_of_service/terms_of_service.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends Mock implements AppBloc {}

class MockAppBlocListenable extends Mock implements AppBlocListenable {}

void main() {
  group('AppRouter', () {
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
}
