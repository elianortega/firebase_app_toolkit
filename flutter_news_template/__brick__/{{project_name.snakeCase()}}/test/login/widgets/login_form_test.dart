// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  const loginFormCloseIconButton = Key('loginForm_closeModal_iconButton');
  const loginButtonKey = Key('loginForm_emailLogin_appButton');
  const signInWithGoogleButtonKey = Key('loginForm_googleLogin_appButton');
  const signInWithAppleButtonKey = Key('loginForm_appleLogin_appButton');
  const signInWithFacebookButtonKey = Key('loginForm_facebookLogin_appButton');
  const signInWithTwitterButtonKey = Key('loginForm_twitterLogin_appButton');

  group('LoginForm', () {
    late LoginBloc loginBloc;

    setUp(() {
      loginBloc = MockLoginBloc();

      when(() => loginBloc.state).thenReturn(const LoginState());
    });

    group('adds', () {
      testWidgets(
          'LoginGoogleSubmitted to LoginBloc '
          'when sign in with google button is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(signInWithGoogleButtonKey));
        await tester.tap(find.byKey(signInWithGoogleButtonKey));
        verify(() => loginBloc.add(LoginGoogleSubmitted())).called(1);
      });

      testWidgets(
          'LoginTwitterSubmitted to LoginBloc '
          'when sign in with Twitter button is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(signInWithTwitterButtonKey));
        await tester.tap(find.byKey(signInWithTwitterButtonKey));
        verify(() => loginBloc.add(LoginTwitterSubmitted())).called(1);
      });

      testWidgets(
          'LoginFacebookSubmitted to LoginBloc '
          'when sign in with Facebook button is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(signInWithFacebookButtonKey));
        await tester.tap(find.byKey(signInWithFacebookButtonKey));
        verify(() => loginBloc.add(LoginFacebookSubmitted())).called(1);
      });

      testWidgets(
          'LoginAppleSubmitted to LoginBloc '
          'when sign in with apple button is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
          platform: TargetPlatform.iOS,
        );
        await tester.ensureVisible(find.byKey(signInWithAppleButtonKey));
        await tester.tap(find.byKey(signInWithAppleButtonKey));
        verify(() => loginBloc.add(LoginAppleSubmitted())).called(1);
      });

      testWidgets('AuthenticationFailure SnackBar when submission fails',
          (tester) async {
        whenListen(
          loginBloc,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzSubmissionStatus.inProgress),
            LoginState(status: FormzSubmissionStatus.failure),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
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
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
          platform: TargetPlatform.iOS,
        );
        expect(find.byKey(signInWithAppleButtonKey), findsOneWidget);
        expect(find.byKey(signInWithGoogleButtonKey), findsOneWidget);
      });

      testWidgets('only Sign in with Google on Android', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
          platform: TargetPlatform.android,
        );
        expect(find.byKey(signInWithAppleButtonKey), findsNothing);
        expect(find.byKey(signInWithGoogleButtonKey), findsOneWidget);
      });

      testWidgets('Sign in with Facebook', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        expect(find.byKey(signInWithFacebookButtonKey), findsOneWidget);
      });

      testWidgets('Sign in with Twitter', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        expect(find.byKey(signInWithTwitterButtonKey), findsOneWidget);
      });
    });

    group('navigates', () {
      testWidgets('pop when close icon is pressed', (tester) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.pop<void>(any())).thenAnswer((_) async {});
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
          router: mockRouter,
        );
        await tester.ensureVisible(find.byKey(loginFormCloseIconButton));
        await tester.tap(find.byKey(loginFormCloseIconButton));
        verify(() => mockRouter.pop<void>()).called(1);
      });

      testWidgets('to LoginWithEmailPage when Continue with email is pressed',
          (tester) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.go(any())).thenAnswer((_) async {});
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
          router: mockRouter,
        );
        await tester.ensureVisible(find.byKey(loginButtonKey));
        await tester.tap(find.byKey(loginButtonKey));
        verify(() => mockRouter.go(LoginWithEmailPageRoute().location))
            .called(1);
      });
    });
  });
}
