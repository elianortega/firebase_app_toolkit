import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/app/app.dart';
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
  setUpAll(() {
    setFirebaseUiIsTestMode(true);
  });
  group('AppRouter', () {
    GoRouter buildRouter(String initialLocation) => GoRouter(
          initialLocation: initialLocation,
          routes: AppRouter.routes,
        );

    final pages = {
      LandingPage.path: LandingPage,
      // TODO(juanleondev): solve Firebase initialization error
      // LoginPage.path: SignInScreen(
      //   auth: MockAuth(),
      //   providers: [
      //     EmailAuthProvider(),
      //   ],
      // ).runtimeType,
      LoginWithEmailPage.path: LoginWithEmailPage,
      TermsOfServicePage.path: TermsOfServicePage,
      UserProfilePage.path: UserProfilePage,
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

Widget buildTestableWidget(Widget widget) {
  return MaterialApp(
    home: widget,
  );
}

const _user = {
  'uid': 'uid',
  'isAnonymous': false,
  'isEmailVerified': false,
};

class MockUser extends Mock implements fba.User {
  @override
  List<fba.UserInfo> get providerData {
    return [
      fba.UserInfo.fromJson({..._user, 'providerId': 'password'}),
      fba.UserInfo.fromJson({..._user, 'providerId': 'google.com'}),
      fba.UserInfo.fromJson({..._user, 'providerId': 'apple.com'}),
      fba.UserInfo.fromJson({..._user, 'providerId': 'phone'})
    ];
  }
}

class MockAuth extends Mock implements fba.FirebaseAuth {
  @override
  fba.User? get currentUser => MockUser();
}
