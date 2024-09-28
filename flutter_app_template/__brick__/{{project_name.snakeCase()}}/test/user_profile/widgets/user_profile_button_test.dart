// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoute extends Mock implements Route<dynamic> {}

void main() {
  group('UserProfileButton', () {
    late AppBloc appBloc;
    late User user;

    setUp(() {
      appBloc = MockAppBloc();
      user = User(id: 'id');
    });

    setUpAll(() {
      registerFallbackValue(MockRoute());
    });

    testWidgets(
        'renders LoginButton '
        'when user is unauthenticated', (tester) async {
      whenListen(
        appBloc,
        Stream.value(AppState.unauthenticated()),
        initialState: AppState.unauthenticated(),
      );

      await tester.pumpApp(
        UserProfileButton(),
        appBloc: appBloc,
      );

      expect(find.byType(LoginButton), findsOneWidget);
      await tester.tap(find.byType(LoginButton));
      await tester.pump();
      expect(find.byType(OpenProfileButton), findsNothing);
    });

    testWidgets(
        'renders OpenProfileButton '
        'when user is authenticated', (tester) async {
      whenListen(
        appBloc,
        Stream.value(AppState.authenticated(user)),
        initialState: AppState.authenticated(user),
      );

      await tester.pumpApp(
        UserProfileButton(),
        appBloc: appBloc,
      );

      expect(find.byType(OpenProfileButton), findsOneWidget);
      expect(find.byType(LoginButton), findsNothing);
    });

    testWidgets(
        'navigates to UserProfilePage '
        'when tapped on OpenProfileButton', (tester) async {
      final mockRouter = MockGoRouter();
      when(() => mockRouter.go(any())).thenAnswer((_) async {});
      whenListen(
        appBloc,
        Stream.value(AppState.authenticated(user)),
        initialState: AppState.authenticated(user),
      );

      await tester.pumpApp(
        UserProfileButton(),
        appBloc: appBloc,
        router: mockRouter,
      );

      await tester.tap(find.byType(OpenProfileButton));
      await tester.pump();
      verify(() => mockRouter.go(UserProfilePageRoute().location)).called(1);
    });

    testWidgets(
        'renders LoginButton '
        'when user is unauthenticated', (tester) async {
      whenListen(
        appBloc,
        Stream.value(AppState.unauthenticated()),
        initialState: AppState.unauthenticated(),
      );

      await tester.pumpApp(
        UserProfileButton(),
        appBloc: appBloc,
      );

      expect(find.byType(LoginButton), findsOneWidget);
      expect(find.byType(OpenProfileButton), findsNothing);
    });
  });
}
