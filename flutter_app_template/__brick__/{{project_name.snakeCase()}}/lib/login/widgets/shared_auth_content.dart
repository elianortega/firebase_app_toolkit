import 'package:app_ui/app_ui.dart' show AppButton, AppSpacing, Assets;
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/l10n/l10n.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharedAuthContent extends StatelessWidget {
  const SharedAuthContent({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xxlg,
      ),
      children: [
        child,
        const SizedBox(height: AppSpacing.lg + AppSpacing.sm),
        const _OrContinueWithText(),
        const SizedBox(height: AppSpacing.lg + AppSpacing.sm),
        _GoogleLoginButton(),
        if (theme.platform == TargetPlatform.iOS) ...[
          const SizedBox(height: AppSpacing.lg),
          _AppleLoginButton(),
        ],
        const SizedBox(height: AppSpacing.lg),
        _FacebookLoginButton(),
        const SizedBox(height: AppSpacing.lg),
        _TwitterLoginButton(),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _OrContinueWithText extends StatelessWidget {
  const _OrContinueWithText();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        const SizedBox(width: AppSpacing.sm),
        Text(
          context.l10n.orContinueWith,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(width: AppSpacing.sm),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _AppleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton.black(
      key: const Key('loginForm_appleLogin_appButton'),
      onPressed: () => context.read<LoginBloc>().add(LoginAppleSubmitted()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.apple.svg(),
          const SizedBox(width: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Assets.images.continueWithApple.svg(),
          ),
        ],
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton.outlinedWhite(
      key: const Key('loginForm_googleLogin_appButton'),
      onPressed: () => context.read<LoginBloc>().add(LoginGoogleSubmitted()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.google.svg(),
          const SizedBox(width: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: Assets.images.continueWithGoogle.svg(),
          ),
        ],
      ),
    );
  }
}

class _FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton.blueDress(
      key: const Key('loginForm_facebookLogin_appButton'),
      onPressed: () => context.read<LoginBloc>().add(LoginFacebookSubmitted()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.facebook.svg(),
          const SizedBox(width: AppSpacing.lg),
          Assets.images.continueWithFacebook.svg(),
        ],
      ),
    );
  }
}

class _TwitterLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton.crystalBlue(
      key: const Key('loginForm_twitterLogin_appButton'),
      onPressed: () => context.read<LoginBloc>().add(LoginTwitterSubmitted()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.twitter.svg(),
          const SizedBox(width: AppSpacing.lg),
          Assets.images.continueWithTwitter.svg(),
        ],
      ),
    );
  }
}
