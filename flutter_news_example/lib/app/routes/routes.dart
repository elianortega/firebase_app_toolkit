import 'package:flutter/widgets.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/home/home.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.unauthenticated:
    case AppStatus.authenticated:
      return [HomePage.page()];
  }
}
