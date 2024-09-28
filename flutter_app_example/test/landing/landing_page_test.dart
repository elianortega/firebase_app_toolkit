// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_app_example/app/router/router.dart';
import 'package:flutter_app_example/landing/landing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers/helpers.dart';

void main() {
  const loginButtonKey = Key('landingPage_login_button');
  const signUpButtonKey = Key('landingPage_signUp_button');

  group('LandingPage', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        LandingPage(),
      );

      expect(find.byKey(loginButtonKey), findsOneWidget);
      expect(find.byKey(signUpButtonKey), findsOneWidget);
    });

    group('navigates', () {
      testWidgets('to LoginPage when login button is pressed', (tester) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.go(any())).thenAnswer((_) async {});

        await tester.pumpApp(
          LandingPage(),
          router: mockRouter,
        );

        await tester.tap(find.byKey(loginButtonKey));
        await tester.pumpAndSettle();

        verify(() => mockRouter.go(LoginPageRoute().location)).called(1);
      });

      testWidgets('to LoginPageRoute when sign up button is pressed',
          (tester) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.go(any())).thenAnswer((_) async {});

        await tester.pumpApp(
          LandingPage(),
          router: mockRouter,
        );

        await tester.tap(find.byKey(signUpButtonKey));
        await tester.pumpAndSettle();

        verify(() => mockRouter.go(LoginPageRoute().location)).called(1);
      });
    });
  });
}
