// TODO(any): Migrate firebase dynamic links to another package
// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_example/main/bootstrap/app_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef AppBuilder = Future<Widget> Function(
  // Ignore, as we currently only use dynamic links for e-mail login.
  // e-mail login will be replaced but not deprecated.
  // source:https://firebase.google.com/support/dynamic-links-faq#im_currently_using_or_need_to_use_dynamic_links_for_email_link_authentication_in_firebase_authentication_will_this_feature_continue_to_work_after_the_sunset
  FirebaseDynamicLinks firebaseDynamicLinks,
  FirebaseMessaging firebaseMessaging,
  SharedPreferences sharedPreferences,
  AnalyticsRepository analyticsRepository,
);

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final analyticsRepository = AnalyticsRepository(FirebaseAnalytics.instance);
  final blocObserver = AppBlocObserver(
    analyticsRepository: analyticsRepository,
  );
  Bloc.observer = blocObserver;
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationSupportDirectory(),
  );

  if (kDebugMode) {
    await HydratedBloc.storage.clear();
  }

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    await builder(
      FirebaseDynamicLinks.instance,
      FirebaseMessaging.instance,
      sharedPreferences,
      analyticsRepository,
    ),
  );
}