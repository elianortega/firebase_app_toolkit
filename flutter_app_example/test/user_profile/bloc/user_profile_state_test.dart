// ignore_for_file: prefer_const_constructors

import 'package:flutter_app_example/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('UserProfileState', () {
    test('initial has correct status', () {
      expect(
        UserProfileState.initial().status,
        equals(UserProfileStatus.initial),
      );
    });

    test('supports value comparisons', () {
      expect(
        UserProfileState.initial(),
        equals(UserProfileState.initial()),
      );
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          UserProfileState.initial().copyWith(),
          equals(UserProfileState.initial()),
        );
      });

      test(
          'returns object with updated user '
          'when user is passed', () {
        expect(
          UserProfileState.initial().copyWith(
            user: User.anonymous,
          ),
          equals(
            UserProfileState(
              status: UserProfileStatus.initial,
              user: User.anonymous,
            ),
          ),
        );
      });
    });
  });
}
