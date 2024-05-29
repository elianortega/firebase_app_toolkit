import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_news_example/app/app.dart';

class RedirectStreamScope extends InheritedNotifier<AppStatusStream> {
  RedirectStreamScope({
    required AppBloc appBloc,
    required super.child,
    super.key,
  }) : super(notifier: AppStatusStream(appBloc, appBloc.stream));

  static AppStatusStream of(BuildContext ctx) =>
      ctx.dependOnInheritedWidgetOfExactType<RedirectStreamScope>()!.notifier!;
}

class AppStatusStream extends ChangeNotifier {
  AppStatusStream(
    AppBloc bloc,
    Stream<dynamic> stream,
  ) : _bloc = bloc {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  final AppBloc _bloc;
  late final StreamSubscription<dynamic> _subscription;

  bool get isSignedIn => _bloc.state.status == AppStatus.authenticated;
  bool get isSignedOut => _bloc.state.status == AppStatus.unauthenticated;
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
