// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter_app_example/terms_of_service/terms_of_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TermsOfServicePage', () {
    group('renders', () {
      testWidgets('terms of service page header', (tester) async {
        await tester.pumpApp(TermsOfServicePage());
        expect(find.byType(TermsOfServiceHeader), findsOneWidget);
      });

      testWidgets('terms of service body', (tester) async {
        await tester.pumpApp(TermsOfServicePage());
        expect(find.byType(TermsOfServiceBody), findsOneWidget);
      });
    });

    group('navigates', () {
      testWidgets('back when tapped on back icon', (tester) async {
        await tester.pumpApp(TermsOfServicePage());

        await tester.tap(find.byType(AppBackButton));
        await tester.pumpAndSettle();

        expect(find.byType(TermsOfServicePage), findsNothing);
      });
    });
  });
}
