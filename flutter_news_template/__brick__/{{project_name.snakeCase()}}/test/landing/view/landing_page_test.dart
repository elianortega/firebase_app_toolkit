import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/landing/view/landing_page.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  const loginButtonKey = Key('landingPage_login_button');
  const signUpButtonKey = Key('landingPage_signUp_button');
  group('LandingPage', () {
    group('navigates', () {
      testWidgets('to Login page when Login button is pressed', (tester) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.push<void>(any())).thenAnswer((_) async {});
        await tester.pumpApp(
          const LandingPage(),
          router: mockRouter,
        );
        await tester.ensureVisible(find.byKey(loginButtonKey));
        await tester.tap(find.byKey(loginButtonKey));
        verify(() => mockRouter.push<void>(LoginPage.path)).called(1);
      });

      testWidgets('to Sign Up page when Sign Up button is pressed',
          (tester) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.push<void>(any())).thenAnswer((_) async {});
        await tester.pumpApp(
          const LandingPage(),
          router: mockRouter,
        );
        await tester.ensureVisible(find.byKey(signUpButtonKey));
        await tester.tap(find.byKey(signUpButtonKey));
        verify(() => mockRouter.push<void>(LoginPage.path)).called(1);
      });
    });
  });
}
