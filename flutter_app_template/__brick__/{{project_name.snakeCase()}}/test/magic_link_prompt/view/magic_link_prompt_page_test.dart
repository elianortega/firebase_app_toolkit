// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/magic_link_prompt/magic_link_prompt.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  const testEmail = 'testEmail@gmail.com';

  group('MagicLinkPromptPage', () {
    test('has a route', () {
      expect(
        MagicLinkPromptPage.route(email: testEmail),
        isA<MaterialPageRoute<void>>(),
      );
    });

    testWidgets('renders a MagicLinkPromptView', (tester) async {
      await tester.pumpApp(
        const MagicLinkPromptPage(email: testEmail),
      );
      expect(find.byType(MagicLinkPromptView), findsOneWidget);
    });

    testWidgets('router returns a valid navigation route', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push<void>(MagicLinkPromptPage.route(email: testEmail));
                },
                child: const Text('Tap me'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('Tap me'));
      await tester.pumpAndSettle();

      expect(find.byType(MagicLinkPromptPage), findsOneWidget);
    });
  });
}
