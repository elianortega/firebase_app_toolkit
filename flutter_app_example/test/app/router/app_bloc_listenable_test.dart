import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app_example/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppBlocBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockCallableClass extends Mock {
  void call();
}

void main() {
  group('AppBlocListenable', () {
    late AppBloc appBloc;

    setUp(() {
      appBloc = MockAppBlocBloc();
      whenListen<AppState>(appBloc, const Stream<AppState>.empty());
    });

    test('constructor', () {
      final appBlocListenable = AppBlocListenable(appBloc: appBloc);
      verify(() => appBloc.stream).called(1);
      expect(appBlocListenable, isNotNull);
    });

    test('dispose', () {
      final appBlocListenable = AppBlocListenable(appBloc: appBloc);
      expect(appBlocListenable.dispose, returnsNormally);
    });

    test('onStreamChange', () async {
      final callableClass = MockCallableClass();
      when(callableClass.call).thenReturn(null);

      whenListen(
        appBloc,
        Stream<AppState>.fromIterable([
          const AppState.unauthenticated(),
        ]),
      );

      AppBlocListenable(
        appBloc: appBloc,
        onChange: callableClass.call,
      );
      await expectLater(
        appBloc.stream,
        emitsInOrder(<AppState>[
          const AppState.unauthenticated(),
        ]),
      );
      verify(callableClass.call).called(1);
    });
  });
}
