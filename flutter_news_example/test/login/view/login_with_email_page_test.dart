import 'package:app_ui/app_ui.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LoginWithEmailPage', () {
    testWidgets('renders LoginWithEmailForm', (tester) async {
      await tester.pumpApp(const LoginWithEmailPage());
      expect(find.byType(LoginWithEmailForm), findsOneWidget);
    });

    group('navigates', () {
      testWidgets('back when leading button is pressed', (tester) async {
        final navigator = MockNavigator();
        when(navigator.canPop).thenReturn(true);
        when(navigator.pop).thenAnswer((_) async {});
        await tester.pumpApp(
          const LoginWithEmailPage(),
          navigator: navigator,
        );
        await tester.tap(find.byType(AppBackButton));
        await tester.pumpAndSettle();
        verify(navigator.pop).called(1);
      });
    });
  });
}
