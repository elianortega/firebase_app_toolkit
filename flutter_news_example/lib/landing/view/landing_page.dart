import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/app/router/app_router.dart';
import 'package:flutter_news_example/l10n/l10n.dart';

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
            Assets.images.logoDark.image(
              height: 64,
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
