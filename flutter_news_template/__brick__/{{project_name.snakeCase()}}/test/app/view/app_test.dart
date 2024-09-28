// ignore_for_file: prefer_const_constructors

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:{{project_name.snakeCase()}}/analytics/analytics.dart' as analytics;
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockAnalyticsBloc
    extends MockBloc<analytics.AnalyticsEvent, analytics.AnalyticsState>
    implements analytics.AnalyticsBloc {}

void main() {
  initMockHydratedStorage();

  group('App', () {
    late UserRepository userRepository;

    late AnalyticsRepository analyticsRepository;
    late User user;

    setUp(() {
      userRepository = MockUserRepository();
      user = User.anonymous;

      analyticsRepository = MockAnalyticsRepository();

      when(() => userRepository.user).thenAnswer((_) => const Stream.empty());
      when(() => userRepository.incomingEmailLinks)
          .thenAnswer((_) => const Stream.empty());
      when(() => userRepository.fetchAppOpenedCount())
          .thenAnswer((_) async => 2);
      when(() => userRepository.incrementAppOpenedCount())
          .thenAnswer((_) async {});
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          userRepository: userRepository,
          analyticsRepository: analyticsRepository,
          user: user,
        ),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late AppBloc appBloc;
    late UserRepository userRepository;

    setUp(() {
      appBloc = MockAppBloc();
      userRepository = MockUserRepository();
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.isAnonymous).thenReturn(false);
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpApp(
        const AppView(),
        appBloc: appBloc,
        userRepository: userRepository,
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
