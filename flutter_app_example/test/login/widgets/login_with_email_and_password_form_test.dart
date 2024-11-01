// ignore_for_file: avoid_redundant_argument_values

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_example/app/app.dart';
import 'package:flutter_app_example/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockEmail extends Mock implements Email {}

void main() {
  const nextButtonKey = Key('loginWithEmailForm_nextButton');
  const emailInputKey = Key('loginWithEmailForm_emailInput_textField');

  const loginWithEmailFormTermsAndPrivacyPolicyKey =
      Key('loginWithEmailForm_terms_and_privacy_policy');
  const loginWithEmailFormClearIconKey =
      Key('loginWithEmailForm_clearIconButton');

  const testEmail = 'test@gmail.com';
  const invalidTestEmail = 'test@g';

  late LoginBloc loginBloc;

  group('LoginWithEmailAndPasswordForm', () {
    setUp(() {
      loginBloc = MockLoginBloc();
      when(() => loginBloc.state).thenReturn(const LoginState());
    });

    group('adds', () {
      testWidgets('LoginEmailChanged when email changes', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginWithEmailAndPasswordForm(),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(() => loginBloc.add(const LoginEmailChanged(testEmail)))
            .called(1);
      });

      testWidgets('LoginSubmitted when next button is pressed', (tester) async {
        when(() => loginBloc.state).thenReturn(
          const LoginState(valid: true),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginWithEmailAndPasswordForm(),
          ),
        );
        await tester.tap(find.byKey(nextButtonKey));
        verify(() => loginBloc.add(const LoginSubmitted())).called(1);
      });

      testWidgets('LoginEmailChanged when pressed on suffixIcon',
          (tester) async {
        when(() => loginBloc.state).thenAnswer(
          (_) => const LoginState(email: Email.dirty(testEmail)),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginWithEmailAndPasswordForm(),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);

        await tester.ensureVisible(find.byKey(loginWithEmailFormClearIconKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(loginWithEmailFormClearIconKey));
        await tester.pumpAndSettle();
        verify(() => loginBloc.add(const LoginEmailChanged(''))).called(1);
      });

      group('renders', () {
        testWidgets('email text field', (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailAndPasswordForm(),
            ),
          );
          final emailTextField = find.byKey(emailInputKey);
          expect(emailTextField, findsOneWidget);
        });

        testWidgets('terms and privacy policy text', (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailAndPasswordForm(),
            ),
          );
          final termsAndPrivacyPolicyText =
              find.byKey(loginWithEmailFormTermsAndPrivacyPolicyKey);
          expect(termsAndPrivacyPolicyText, findsOneWidget);
        });

        testWidgets('disabled next button when status is not validated',
            (tester) async {
          when(() => loginBloc.state).thenReturn(
            const LoginState(valid: false),
          );
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailAndPasswordForm(),
            ),
          );
          final signUpButton = tester.widget<AppButton>(
            find.byKey(nextButtonKey),
          );
          expect(signUpButton.onPressed, null);
        });

        testWidgets('disabled next button when invalid email is added',
            (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailAndPasswordForm(),
            ),
          );
          await tester.enterText(find.byKey(emailInputKey), invalidTestEmail);
          final signUpButton = tester.widget<AppButton>(
            find.byKey(nextButtonKey),
          );
          expect(signUpButton.onPressed, null);
        });

        testWidgets('enabled next button when status is validated',
            (tester) async {
          when(() => loginBloc.state).thenReturn(
            const LoginState(valid: true),
          );
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailAndPasswordForm(),
            ),
          );
          final signUpButton = tester.widget<AppButton>(
            find.byKey(nextButtonKey),
          );
          expect(signUpButton.onPressed, isNotNull);
        });
      });
    });

    group('navigates', () {
      testWidgets(
          'to TermsOfServicePage when tapped on '
          'Terms of Use and Privacy Policy text', (tester) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.push<void>(any())).thenAnswer((_) async {});
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginWithEmailAndPasswordForm(),
          ),
          router: mockRouter,
        );
        final richText = tester.widget<RichText>(
          find.byKey(loginWithEmailFormTermsAndPrivacyPolicyKey),
        );

        tapTextSpan(
          richText,
          'Terms of Use and Privacy Policy',
        );

        await tester.pumpAndSettle();
        verify(
          () => mockRouter.push<void>(const TermsOfServicePageRoute().location),
        ).called(1);
      });
    });

    group('disables', () {
      testWidgets('email text field when status is inProgress', (tester) async {
        when(() => loginBloc.state).thenAnswer(
          (_) => const LoginState(status: FormzSubmissionStatus.inProgress),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginWithEmailAndPasswordForm(),
          ),
        );
        final emailTextField = tester.widget<AppEmailTextField>(
          find.byKey(emailInputKey),
        );
        expect(emailTextField.readOnly, isTrue);
      });

      testWidgets('clear icon button when status is inProgress',
          (tester) async {
        when(() => loginBloc.state).thenAnswer(
          (_) => const LoginState(status: FormzSubmissionStatus.inProgress),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginWithEmailAndPasswordForm(),
          ),
        );
        final clearIcon = tester.widget<ClearIconButton>(
          find.byType(ClearIconButton),
        );
        expect(clearIcon.onPressed, null);
      });
    });
  });
}

void tapTextSpan(RichText richText, String text) =>
    richText.text.visitChildren((visitor) {
      if (visitor is TextSpan && visitor.text == text) {
        final recognizer = visitor.recognizer;
        if (recognizer is TapGestureRecognizer) {
          recognizer.onTap!();
        }
        return false;
      }
      return true;
    });
