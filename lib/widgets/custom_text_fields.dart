import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {
  /// to show mandatory symbol
  final bool required;
  final double? height;
  final double? width;
  final bool readonly;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final String? initialValue;
  final int? maxLines;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool showCounter;
  final bool disabled;
  final AutovalidateMode autovalidateMode;
  final double suffixConstraintHeight;
  final double suffixConstraintWidth;
  final bool showSuffixIcon;
  final TextStyle? style;

  const CustomTextfield({
    Key? key,
    this.height,
    this.width,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.initialValue,
    this.maxLines,
    this.labelStyle,
    this.hintStyle,
    this.required = false,
    this.obscureText = false,
    this.readonly = false,
    this.textCapitalization = TextCapitalization.none,
    this.showCounter = false,
    this.disabled = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.suffixConstraintHeight=20.0,
    this.suffixConstraintWidth=20.0,
    this.showSuffixIcon=true,
    this.style
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: TextFormField(
          autovalidateMode: autovalidateMode,
          onTap: onTap,
          enableSuggestions: false,
          autocorrect: false,
          readOnly: readonly,
          focusNode: focusNode,
          controller: controller,
          initialValue: initialValue,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          validator: validator,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          obscureText: obscureText,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          style: style ?? Theme.of(context).textTheme.bodyText1,
          decoration: InputDecoration(
            counterText: showCounter ? null : '',
            hintText: hintText,
            hintStyle: hintStyle,
            prefixIcon: prefixIcon,
            suffixIcon: showSuffixIcon?Container(
              constraints:  BoxConstraints(maxHeight: suffixConstraintHeight, maxWidth: suffixConstraintWidth),
              child: suffixIcon,
            ):null,
            errorMaxLines: 5,
            label: RichText(
              text: TextSpan(
                text: labelText,
                style: labelStyle ?? Theme.of(context).textTheme.bodyText1,
                children: [
                  if (required)
                    TextSpan(
                      text: '*',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
