// ignore_for_file: prefer_const_constructors
import 'package:flutter_app_example/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginEvent', () {
    group('LoginEmailChanged', () {
      test('supports value comparisons', () {
        expect(
          LoginEmailChanged('test@gmail.com'),
          LoginEmailChanged('test@gmail.com'),
        );
        expect(
          LoginEmailChanged(''),
          isNot(LoginEmailChanged('test@gmail.com')),
        );
      });
    });

    group('LoginPasswordChanged', () {
      test('supports value comparisons', () {
        expect(
          LoginPasswordChanged('p@ssw0rd1234'),
          LoginPasswordChanged('p@ssw0rd1234'),
        );
        expect(
          LoginPasswordChanged(''),
          isNot(LoginPasswordChanged('p@ssw0rd1234')),
        );
      });
    });

    group('LoginGoogleSubmitted', () {
      test('supports value comparisons', () {
        expect(LoginGoogleSubmitted(), LoginGoogleSubmitted());
      });
    });

    group('LoginTwitterSubmitted', () {
      test('supports value comparisons', () {
        expect(LoginTwitterSubmitted(), LoginTwitterSubmitted());
      });
    });

    group('LoginFacebookSubmitted', () {
      test('supports value comparisons', () {
        expect(LoginFacebookSubmitted(), LoginFacebookSubmitted());
      });
    });

    group('LoginAppleSubmitted', () {
      test('supports value comparisons', () {
        expect(LoginAppleSubmitted(), LoginAppleSubmitted());
      });
    });
  });
}
