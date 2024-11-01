// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_example/analytics/analytics.dart';
import 'package:flutter_app_example/app/app.dart';
import 'package:flutter_app_example/user_profile/user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockUserProfileBloc extends MockBloc<UserProfileEvent, UserProfileState>
    implements UserProfileBloc {}

class MockAnalyticsBloc extends MockBloc<AnalyticsEvent, AnalyticsState>
    implements AnalyticsBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  const termsOfServiceItemKey = Key('userProfilePage_termsOfServiceItem');

  group('UserProfilePage', () {
    testWidgets('renders UserProfileView', (tester) async {
      await tester.pumpApp(UserProfilePage());
      expect(find.byType(UserProfileView), findsOneWidget);
    });

    group('UserProfileView', () {
      late UserProfileBloc userProfileBloc;
      late AppBloc appBloc;

      final user = User(
        id: '1',
        email: 'email',
      );

      setUp(() {
        userProfileBloc = MockUserProfileBloc();
        appBloc = MockAppBloc();

        final initialState = UserProfileState.initial().copyWith(
          user: user,
        );

        whenListen(
          userProfileBloc,
          Stream.value(initialState),
          initialState: initialState,
        );

        whenListen(
          appBloc,
          Stream.fromIterable(
            <AppState>[AppState.unauthenticated()],
          ),
          initialState: AppState.authenticated(user),
        );
      });

      testWidgets(
          'navigates back '
          'when app back button is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );

        await tester.tap(find.byType(AppBackButton));
        await tester.pumpAndSettle();

        expect(find.byType(UserProfileView), findsNothing);
      });

      testWidgets('renders UserProfileTitle', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );

        expect(
          find.byType(UserProfileTitle),
          findsOneWidget,
        );
      });

      testWidgets('renders user email', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );

        expect(
          find.byWidgetPredicate(
            (widget) => widget is UserProfileItem && widget.title == user.email,
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders terms of use and privacy policy item',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is UserProfileItem &&
                widget.key == Key('userProfilePage_termsOfServiceItem'),
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders about item', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is UserProfileItem &&
                widget.key == Key('userProfilePage_aboutItem'),
          ),
          findsOneWidget,
        );
      });

      group('UserProfileItem', () {
        testWidgets('renders ListTile', (tester) async {
          await tester.pumpApp(
            UserProfileItem(
              title: 'title',
            ),
          );

          expect(find.widgetWithText(ListTile, 'title'), findsOneWidget);
        });

        testWidgets('renders leading', (tester) async {
          const leadingKey = Key('__leading__');

          await tester.pumpApp(
            UserProfileItem(
              title: 'title',
              leading: SizedBox(key: leadingKey),
            ),
          );

          expect(find.byKey(leadingKey), findsOneWidget);
        });

        testWidgets('renders trailing', (tester) async {
          const trailingKey = Key('__trailing__');

          await tester.pumpApp(
            UserProfileItem(
              title: 'title',
              trailing: SizedBox(key: trailingKey),
            ),
          );

          expect(find.byKey(trailingKey), findsOneWidget);
        });

        testWidgets('calls onTap when tapped', (tester) async {
          var tapped = false;
          await tester.pumpApp(
            UserProfileItem(
              title: 'title',
              onTap: () => tapped = true,
            ),
          );

          await tester.tap(find.byType(UserProfileItem));

          expect(tapped, isTrue);
        });
      });

      group('UserProfileLogoutButton', () {
        testWidgets('renders AppButton', (tester) async {
          await tester.pumpApp(UserProfileLogoutButton());
          expect(find.byType(AppButton), findsOneWidget);
        });

        testWidgets(
            'adds AppLogoutRequested to AppBloc '
            'when tapped', (tester) async {
          await tester.pumpApp(
            UserProfileLogoutButton(),
            appBloc: appBloc,
          );

          await tester.tap(find.byType(UserProfileLogoutButton));

          verify(() => appBloc.add(AppLogoutRequested())).called(1);
        });
      });

      group('navigates', () {
        testWidgets('when tapped on Terms of User & Privacy Policy',
            (tester) async {
          final mockRouter = MockGoRouter();
          when(() => mockRouter.push<void>(any())).thenAnswer((_) async {});
          await tester.pumpApp(
            BlocProvider.value(
              value: userProfileBloc,
              child: UserProfileView(),
            ),
            router: mockRouter,
          );

          final termsOfService = find.byKey(termsOfServiceItemKey);

          await tester.dragUntilVisible(
            termsOfService,
            find.byType(UserProfileView),
            Offset(0, -100),
            duration: Duration.zero,
          );
          await tester.pumpAndSettle();
          await tester.ensureVisible(termsOfService);
          await tester.tap(termsOfService);
          verify(
            () => mockRouter.push<void>(TermsOfServicePageRoute().location),
          ).called(1);
        });
      });

      group('shows', () {
        testWidgets(
            'UserProfileDeleteAccountDialog '
            'when tapped on Delete account', (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: userProfileBloc,
              child: UserProfileView(),
            ),
          );

          final deleteAccountButton = find.byKey(
            Key('userProfilePage_deleteAccountButton'),
          );
          await tester.dragUntilVisible(
            deleteAccountButton,
            find.byType(UserProfileView),
            Offset(0, -100),
            duration: Duration.zero,
          );
          await tester.pumpAndSettle();

          await tester.ensureVisible(deleteAccountButton);
          await tester.tap(deleteAccountButton);
          await tester.pumpAndSettle();

          expect(find.byType(UserProfileDeleteAccountDialog), findsOneWidget);
        });
      });
    });
  });
}
