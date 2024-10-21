import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_example/app/app.dart';
import 'package:flutter_app_example/l10n/l10n.dart';
import 'package:flutter_app_example/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';

class LoginWithEmailAndPasswordForm extends StatelessWidget {
  const LoginWithEmailAndPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _EmailInput(),
        _PasswordInput(),
        _TermsAndPrivacyPolicyLinkTexts(),
        SizedBox(height: AppSpacing.lg),
        _NextButton(),
      ],
    );
  }
}

class _EmailInput extends StatefulWidget {
  const _EmailInput();

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final status = context.select((LoginBloc bloc) => bloc.state.status);

    return AppEmailTextField(
      key: const Key('loginWithEmailForm_emailInput_textField'),
      controller: _controller,
      readOnly: status.isInProgress,
      hintText: context.l10n.loginWithEmailTextFieldHint,
      onChanged: (email) =>
          context.read<LoginBloc>().add(LoginEmailChanged(email)),
      suffix: ClearIconButton(
        onPressed: !status.isInProgress
            ? () {
                _controller.clear();
                context.read<LoginBloc>().add(const LoginEmailChanged(''));
              }
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _PasswordInput extends StatefulWidget {
  const _PasswordInput();

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final status = context.select((LoginBloc bloc) => bloc.state.status);

    return AppPasswordTextField(
      key: const Key('loginWithEmailForm_passwordInput_textField'),
      controller: _controller,
      readOnly: status.isInProgress,
      hintText: context.l10n.loginWithEmailPasswordTextFieldHint,
      onChanged: (password) =>
          context.read<LoginBloc>().add(LoginPasswordChanged(password)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _TermsAndPrivacyPolicyLinkTexts extends StatelessWidget {
  const _TermsAndPrivacyPolicyLinkTexts();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: RichText(
        key: const Key('loginWithEmailForm_terms_and_privacy_policy'),
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: context.l10n.loginWithEmailSubtitleText,
              style: theme.textTheme.bodyLarge,
            ),
            TextSpan(
              text: context.l10n.loginWithEmailTermsAndPrivacyPolicyText,
              style: theme.textTheme.bodyLarge?.apply(
                color: AppColors.darkAqua,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => const TermsOfServicePageRoute().go(context),
            ),
            TextSpan(
              text: '.',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<LoginBloc>().state;

    return AppButton.darkAqua(
      key: const Key('loginWithEmailForm_nextButton'),
      onPressed: state.valid
          ? () {
              context.read<LoginBloc>().add(const LoginSubmitted());
            }
          : null,
      child: state.status.isInProgress
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(),
            )
          : Text(l10n.nextButtonText),
    );
  }
}

@visibleForTesting
class ClearIconButton extends StatelessWidget {
  const ClearIconButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final suffixVisible =
        context.select((LoginBloc bloc) => bloc.state.email.value.isNotEmpty);

    return Padding(
      key: const Key('loginWithEmailForm_clearIconButton'),
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: Visibility(
        visible: suffixVisible,
        child: GestureDetector(
          onTap: onPressed,
          child: const Icon(Icons.clear),
        ),
      ),
    );
  }
}
