// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_example/app/app.dart';
import 'package:flutter_app_example/home/home.dart';
import 'package:flutter_app_example/navigation/navigation.dart';
import 'package:flutter_app_example/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockAppBloc extends Mock implements AppBloc {}

void main() {
  initMockHydratedStorage();

  late HomeCubit cubit;
  late AppBloc appBloc;

  setUp(() {
    cubit = MockHomeCubit();
    appBloc = MockAppBloc();

    when(() => appBloc.state).thenReturn(
      AppState(
        showLoginOverlay: false,
        status: AppStatus.unauthenticated,
      ),
    );

    when(() => cubit.state).thenReturn(HomeState.topStories);
  });
  group('HomeView', () {
    testWidgets('renders AppBar with AppLogo', (tester) async {
      when(() => cubit.state).thenReturn(HomeState.topStories);

      await pumpHomeView(
        tester: tester,
        cubit: cubit,
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is AppBar && widget.title is AppLogo,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders UserProfileButton', (tester) async {
      when(() => cubit.state).thenReturn(HomeState.topStories);

      await pumpHomeView(
        tester: tester,
        cubit: cubit,
      );

      expect(find.byType(UserProfileButton), findsOneWidget);
    });

    testWidgets(
        'renders NavDrawer '
        'when menu icon is tapped', (tester) async {
      when(() => cubit.state).thenReturn(HomeState.topStories);

      await pumpHomeView(
        tester: tester,
        cubit: cubit,
      );

      expect(find.byType(NavDrawer), findsNothing);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();

      expect(find.byType(NavDrawer), findsOneWidget);
    });

    testWidgets('verify hasFocus after HomeState changes',
        (widgetTester) async {
      when(() => cubit.state).thenReturn(HomeState.topStories);
      whenListen(
        cubit,
        Stream.fromIterable([
          HomeState.topStories,
          HomeState.search,
        ]),
      );
      await pumpHomeView(
        tester: widgetTester,
        cubit: cubit,
      );
      await widgetTester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus, isNotNull);
    });

    testWidgets('tapping on BottomNavBar changes tab', (tester) async {
      final button = find.byKey(const Key('bottomNavBar_topStories'));
      when(() => cubit.state).thenReturn(HomeState.topStories);
      when(() => cubit.setTab(0)).thenReturn(null);
      await pumpHomeView(
        tester: tester,
        cubit: cubit,
      );
      await tester.tap(button);
      await tester.pumpAndSettle();
      verify(() => cubit.setTab(0)).called(1);
    });
  });
}

Future<void> pumpHomeView({
  required WidgetTester tester,
  required HomeCubit cubit,
  AppBloc? appBloc,
}) async {
  await tester.pumpApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: cubit,
        ),
      ],
      child: HomeView(),
    ),
    appBloc: appBloc,
  );
}
