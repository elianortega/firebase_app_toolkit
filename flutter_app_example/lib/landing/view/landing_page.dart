import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_example/app/router/app_router.dart';
import 'package:flutter_app_example/l10n/l10n.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
              width: 128,
              height: 128,
            ),
            const SizedBox(height: AppSpacing.xxlg),
            Text(
              'Flutter App Example',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: AppSpacing.xxlg),
            AppButton.black(
              key: const Key('landingPage_login_button'),
              onPressed: () {
                const LoginPageRoute().go(context);
              },
              child: Text(l10n.loginButtonText),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton.black(
              key: const Key('landingPage_signUp_button'),
              onPressed: () {
                const LoginPageRoute().go(context);
              },
              child: Text(l10n.signUpButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
