import 'package:app_ui/app_ui.dart' show AppSpacing;
import 'package:flutter/material.dart';
import 'package:flutter_app_example/l10n/l10n.dart';
import 'package:flutter_app_example/login/login.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharedAuthContent(
      child: Column(
        children: [
          _LoginTitleAndSubtitle(),
          SizedBox(height: AppSpacing.lg),
          LoginWithEmailAndPasswordForm(),
        ],
      ),
    );
  }
}

class _LoginTitleAndSubtitle extends StatelessWidget {
  const _LoginTitleAndSubtitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.loginPageTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          context.l10n.loginPageSubtitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
