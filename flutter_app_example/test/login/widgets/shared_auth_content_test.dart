// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_example/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  const signInWithGoogleButtonKey = Key('loginForm_googleLogin_appButton');
  const signInWithAppleButtonKey = Key('loginForm_appleLogin_appButton');
  const signInWithFacebookButtonKey = Key('loginForm_facebookLogin_appButton');
  const signInWithTwitterButtonKey = Key('loginForm_twitterLogin_appButton');

  group('SharedAuthContent', () {
    late LoginBloc loginBloc;

    setUp(() {
      loginBloc = MockLoginBloc();

      when(() => loginBloc.state).thenReturn(const LoginState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: loginBloc,
        child: SharedAuthContent(child: SizedBox()),
      );
    }

    group('adds', () {
      testWidgets(
          'LoginGoogleSubmitted to LoginBloc '
          'when sign in with google button is pressed', (tester) async {
        await tester.pumpApp(buildSubject());
        await tester.ensureVisible(find.byKey(signInWithGoogleButtonKey));
        await tester.tap(find.byKey(signInWithGoogleButtonKey));
        verify(() => loginBloc.add(LoginGoogleSubmitted())).called(1);
      });

      testWidgets(
          'LoginTwitterSubmitted to LoginBloc '
          'when sign in with Twitter button is pressed', (tester) async {
        await tester.pumpApp(buildSubject());
        await tester.ensureVisible(find.byKey(signInWithTwitterButtonKey));
        await tester.tap(find.byKey(signInWithTwitterButtonKey));
        verify(() => loginBloc.add(LoginTwitterSubmitted())).called(1);
      });

      testWidgets(
          'LoginFacebookSubmitted to LoginBloc '
          'when sign in with Facebook button is pressed', (tester) async {
        await tester.pumpApp(buildSubject());
        await tester.ensureVisible(find.byKey(signInWithFacebookButtonKey));
        await tester.tap(find.byKey(signInWithFacebookButtonKey));
        verify(() => loginBloc.add(LoginFacebookSubmitted())).called(1);
      });

      testWidgets(
          'LoginAppleSubmitted to LoginBloc '
          'when sign in with apple button is pressed', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          platform: TargetPlatform.iOS,
        );
        await tester.ensureVisible(find.byKey(signInWithAppleButtonKey));
        await tester.tap(find.byKey(signInWithAppleButtonKey));
        verify(() => loginBloc.add(LoginAppleSubmitted())).called(1);
      });

      testWidgets('nothing when login is canceled', (tester) async {
        whenListen(
          loginBloc,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzSubmissionStatus.inProgress),
            LoginState(status: FormzSubmissionStatus.canceled),
          ]),
        );
      });
    });

    group('renders', () {
      testWidgets('Sign in with Google and Apple on iOS', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          platform: TargetPlatform.iOS,
        );
        expect(find.byKey(signInWithAppleButtonKey), findsOneWidget);
        expect(find.byKey(signInWithGoogleButtonKey), findsOneWidget);
      });

      testWidgets('only Sign in with Google on Android', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          platform: TargetPlatform.android,
        );
        expect(find.byKey(signInWithAppleButtonKey), findsNothing);
        expect(find.byKey(signInWithGoogleButtonKey), findsOneWidget);
      });

      testWidgets('Sign in with Facebook', (tester) async {
        await tester.pumpApp(buildSubject());
        expect(find.byKey(signInWithFacebookButtonKey), findsOneWidget);
      });

      testWidgets('Sign in with Twitter', (tester) async {
        await tester.pumpApp(buildSubject());
        expect(find.byKey(signInWithTwitterButtonKey), findsOneWidget);
      });
    });
  });
}
