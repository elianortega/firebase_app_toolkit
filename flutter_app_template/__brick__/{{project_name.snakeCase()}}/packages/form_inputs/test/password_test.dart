// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  const passwordString = 'p@ssw0rd1234';

  group('Password', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        final password = Password.pure();
        expect(password.value, '');
        expect(password.isPure, true);
      });

      test('dirty creates correct instance', () {
        final password = Password.dirty(passwordString);
        expect(password.value, passwordString);
        expect(password.isPure, false);
      });
    });

    group('validator', () {
      test('returns empty error when password is empty', () {
        expect(
          Password.dirty().error,
          PasswordValidationError.empty,
        );
      });

      test(
        'returns tooShort error when password is less than 8 characters',
        () {
          expect(
            Password.dirty('1234567').error,
            PasswordValidationError.tooShort,
          );
        },
      );

      test('is valid when password is valid', () {
        final password = Password.dirty(passwordString);
        expect(
          password.error,
          isNull,
        );
        expect(password.isValid, true);
      });
    });
  });
}
