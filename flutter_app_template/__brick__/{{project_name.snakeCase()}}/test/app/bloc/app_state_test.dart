// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppState', () {
    late User user;

    setUp(() {
      user = MockUser();
    });

    group('unauthenticated', () {
      test('has correct status', () {
        final state = AppState.unauthenticated();
        expect(state.status, AppStatus.unauthenticated);
        expect(state.user, User.anonymous);
      });
    });

    group('authenticated', () {
      test('has correct status', () {
        final state = AppState.authenticated(user);
        expect(state.status, AppStatus.authenticated);
        expect(state.user, user);
      });
    });

    group('AppStatus', () {
      test(
          'authenticated is the only statuses '
          'where loggedIn is true', () {
        expect(
          AppStatus.values.where((e) => e.isLoggedIn).toList(),
          equals(
            [
              AppStatus.authenticated,
            ],
          ),
        );
      });
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          AppState.unauthenticated().copyWith(),
          equals(AppState.unauthenticated()),
        );
      });

      test(
          'returns object with updated status '
          'when status is passed', () {
        expect(
          AppState.unauthenticated().copyWith(
            status: AppStatus.authenticated,
          ),
          equals(
            AppState(
              status: AppStatus.authenticated,
            ),
          ),
        );
      });

      test(
          'returns object with updated user '
          'when user is passed', () {
        expect(
          AppState.unauthenticated().copyWith(
            user: user,
          ),
          equals(
            AppState(
              status: AppStatus.unauthenticated,
              user: user,
            ),
          ),
        );
      });
    });
  });
}
