import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LoginPage', () {
    group('renders', () {
      testWidgets('LoginView', (tester) async {
        await tester.pumpApp(
          const LoginPage(),
        );
        expect(find.byType(LoginView), findsOneWidget);
      });
    });
  });
}
