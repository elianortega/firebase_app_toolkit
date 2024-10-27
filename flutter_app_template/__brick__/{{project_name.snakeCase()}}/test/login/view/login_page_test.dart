import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  group('LoginPage', () {
    group('renders', () {
      testWidgets('LoginView', (tester) async {
        await tester.pumpApp(
          const LoginPage(),
        );
        expect(find.byType(LoginView), findsOneWidget);
      });
    });
  });

  group('LoginView', () {
    late LoginBloc loginBloc;

    setUp(() {
      loginBloc = MockLoginBloc();
      when(() => loginBloc.state).thenReturn(const LoginState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: loginBloc,
        child: const LoginView(),
      );
    }

    group('renders', () {
      testWidgets('LoginContent', (tester) async {
        await tester.pumpApp(buildSubject());
        expect(find.byType(LoginContent), findsOneWidget);
      });
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
        buildSubject(),
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
