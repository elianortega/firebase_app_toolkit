import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_example/app/app.dart';

class AppBlocListenable extends ChangeNotifier {
  AppBlocListenable({
    required AppBloc appBloc,
    this.onChange,
  }) : _appBloc = appBloc {
    _appBlocSubscription = _appBloc.stream.listen(_onStreamChange);
  }

  final AppBloc _appBloc;
  final VoidCallback? onChange;
  late final StreamSubscription<AppState> _appBlocSubscription;

  @override
  void dispose() {
    _appBlocSubscription.cancel();
    super.dispose();
  }

  void _onStreamChange(event) {
    notifyListeners();
    onChange?.call();
  }
}
