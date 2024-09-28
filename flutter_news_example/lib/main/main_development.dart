import 'package:deep_link_client/deep_link_client.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:firebase_deep_link_client/firebase_deep_link_client.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/main/bootstrap/bootstrap.dart';
import 'package:flutter_news_example/src/version.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    (
      firebaseDynamicLinks,
      firebaseMessaging,
      sharedPreferences,
      analyticsRepository,
    ) async {
      final tokenStorage = InMemoryTokenStorage();

      final persistentStorage = PersistentStorage(
        sharedPreferences: sharedPreferences,
      );

      final packageInfoClient = PackageInfoClient(
        appName: 'Flutter News Example [DEV]',
        packageName: 'com.somnio.app.example.dev',
        packageVersion: packageVersion,
      );

      final deepLinkService = DeepLinkService(
        deepLinkClient: FirebaseDeepLinkClient(
          firebaseDynamicLinks: firebaseDynamicLinks,
        ),
      );

      final userStorage = UserStorage(storage: persistentStorage);

      final authenticationClient = FirebaseAuthenticationClient(
        tokenStorage: tokenStorage,
      );

      final userRepository = UserRepository(
        authenticationClient: authenticationClient,
        packageInfoClient: packageInfoClient,
        deepLinkService: deepLinkService,
        storage: userStorage,
      );

      return App(
        userRepository: userRepository,
        analyticsRepository: analyticsRepository,
        user: await userRepository.user.first,
      );
    },
  );
}
