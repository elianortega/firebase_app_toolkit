// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:{{project_name.snakeCase()}}/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  initMockHydratedStorage();

  testWidgets('renders a HomeView', (tester) async {
    await tester.pumpApp(const HomePage());

    expect(find.byType(HomeView), findsOneWidget);
  });
}
