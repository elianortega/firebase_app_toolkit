// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app_example/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AppBloc', () {
    late User user;
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
      user = MockUser();

      when(() => userRepository.user).thenAnswer((_) => Stream.empty());
      when(() => user.isNewUser).thenReturn(User.anonymous.isNewUser);
      when(() => user.id).thenReturn(User.anonymous.id);
    });

    test('initial state is unauthenticated when user is anonymous', () {
      expect(
        AppBloc(
          userRepository: userRepository,
          user: User.anonymous,
        ).state.status,
        equals(AppStatus.unauthenticated),
      );
    });

    group('AppUserChanged', () {
      late User returningUser;
      late User newUser;

      setUp(() {
        returningUser = MockUser();
        newUser = MockUser();
        when(() => returningUser.isNewUser).thenReturn(false);
        when(() => returningUser.id).thenReturn('id');
        when(() => newUser.isNewUser).thenReturn(true);
        when(() => newUser.id).thenReturn('id');
      });

      blocTest<AppBloc, AppState>(
        'emits nothing when '
        'state is unauthenticated and user is anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.anonymous),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when user is returning and not anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(returningUser),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        expect: () => [AppState.authenticated(returningUser)],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated '
        'when authenticated user changes',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(returningUser),
          );
        },
        seed: () => AppState.authenticated(user),
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        expect: () => [AppState.authenticated(returningUser)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.anonymous),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        expect: () => [AppState.unauthenticated()],
      );

      blocTest<AppBloc, AppState>(
        'emits nothing when '
        'state is unauthenticated and user is anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.anonymous),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
      );
    });

    group('AppLogoutRequested', () {
      setUp(() {
        when(() => userRepository.logOut()).thenAnswer((_) async {});
      });

      blocTest<AppBloc, AppState>(
        'calls logOut on UserRepository',
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => userRepository.logOut()).called(1);
        },
      );
    });

    group('AppDeleteAccountRequested', () {
      setUp(() {
        when(() => userRepository.deleteAccount()).thenAnswer((_) async {});
        when(() => userRepository.logOut()).thenAnswer((_) async {});
      });

      blocTest<AppBloc, AppState>(
        'calls deleteAccount on UserRepository',
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppDeleteAccountRequested()),
        verify: (_) {
          verify(() => userRepository.deleteAccount()).called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'calls logOut when deleteAccount on UserRepository fails',
        setUp: () {
          when(() => userRepository.deleteAccount()).thenThrow(Exception());
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppDeleteAccountRequested()),
        verify: (_) {
          verify(() => userRepository.deleteAccount()).called(1);
          verify(() => userRepository.logOut()).called(1);
        },
      );
    });

    group('close', () {
      late StreamController<User> userController;

      setUp(() {
        userController = StreamController<User>();

        when(() => userRepository.user)
            .thenAnswer((_) => userController.stream);
      });

      blocTest<AppBloc, AppState>(
        'cancels UserRepository.user subscription',
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        tearDown: () => expect(userController.hasListener, isFalse),
      );
    });

    group('AppOpened', () {
      blocTest<AppBloc, AppState>(
        'calls UserRepository.incrementAppOpenedCount '
        'and emits showLoginOverlay as true '
        'when fetchAppOpenedCount returns a count value of 4 '
        'and user is anonymous',
        setUp: () {
          when(() => userRepository.fetchAppOpenedCount())
              .thenAnswer((_) async => 4);
          when(() => userRepository.incrementAppOpenedCount())
              .thenAnswer((_) async {});
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppOpened()),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[
          AppState(
            showLoginOverlay: true,
            status: AppStatus.unauthenticated,
          ),
        ],
        verify: (_) {
          verify(
            () => userRepository.incrementAppOpenedCount(),
          ).called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'calls UserRepository.incrementAppOpenedCount '
        'when fetchAppOpenedCount returns a count value of 3 '
        'and user is anonymous',
        setUp: () {
          when(() => userRepository.fetchAppOpenedCount())
              .thenAnswer((_) async => 3);
          when(() => userRepository.incrementAppOpenedCount())
              .thenAnswer((_) async {});
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppOpened()),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
        verify: (_) {
          verify(
            () => userRepository.incrementAppOpenedCount(),
          ).called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'does not call UserRepository.incrementAppOpenedCount '
        'when fetchAppOpenedCount returns a count value of 6 '
        'and user is anonymous',
        setUp: () {
          when(() => userRepository.fetchAppOpenedCount())
              .thenAnswer((_) async => 6);
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppOpened()),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
        verify: (_) {
          verifyNever(
            () => userRepository.incrementAppOpenedCount(),
          );
        },
      );
    });
  });
}
