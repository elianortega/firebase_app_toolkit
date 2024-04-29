// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/home/home.dart';
import 'package:{{project_name.snakeCase()}}/navigation/navigation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

const _scaffoldKey = Key('__scaffold__');

extension on WidgetTester {
  Future<void> pumpDrawer({
    required AppBloc appBloc,
    required HomeCubit homeCubit,
  }) async {
    await pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: appBloc,
          ),
          BlocProvider.value(
            value: homeCubit,
          ),
        ],
        child: Scaffold(
          key: _scaffoldKey,
          drawer: NavDrawer(),
          body: Container(),
        ),
      ),
    );

    firstState<ScaffoldState>(find.byKey(_scaffoldKey)).openDrawer();
    await pumpAndSettle();
  }
}

void main() {
  group('NavDrawer', () {
    late AppBloc appBloc;
    late HomeCubit homeCubit;
    late User user;

    setUp(() {
      appBloc = MockAppBloc();
      homeCubit = MockHomeCubit();
      user = MockUser();

      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
    });

    testWidgets('renders Drawer', (tester) async {
      await tester.pumpDrawer(
        appBloc: appBloc,
        homeCubit: homeCubit,
      );
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('renders AppLogo', (tester) async {
      await tester.pumpDrawer(
        appBloc: appBloc,
        homeCubit: homeCubit,
      );
      expect(find.byType(AppLogo), findsOneWidget);
    });
  });
}
