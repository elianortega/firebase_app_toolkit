import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_news_example/app/app.dart';

class AppBlocListenable extends ChangeNotifier {
  AppBlocListenable(AppBloc appBloc) : _appBloc = appBloc {
    appBlocSubscription = _appBloc.stream.listen(_onStreamChange);
  }

  final AppBloc _appBloc;
  late final StreamSubscription<AppState> appBlocSubscription;

  @override
  void dispose() {
    appBlocSubscription.cancel();
    super.dispose();
  }

  void _onStreamChange(event) {
    notifyListeners();
  }
}
