import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_password_text_field}
/// An email text field component.
/// {@endtemplate}
class AppPasswordTextField extends StatefulWidget {
  /// {@macro app_password_text_field}
  const AppPasswordTextField({
    super.key,
    this.controller,
    this.hintText,
    this.readOnly,
    this.onChanged,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool? readOnly;

  @override
  State<AppPasswordTextField> createState() => _AppPasswordTextFieldState();
}

class _AppPasswordTextFieldState extends State<AppPasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      keyboardType: TextInputType.emailAddress,
      autoFillHints: const [AutofillHints.email],
      autocorrect: false,
      obscureText: obscureText,
      prefix: const Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
        ),
        child: Icon(
          Icons.password_outlined,
          color: AppColors.mediumEmphasisSurface,
          size: 24,
        ),
      ),
      readOnly: widget.readOnly ?? false,
      onChanged: widget.onChanged,
      suffix: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
