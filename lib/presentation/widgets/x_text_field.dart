// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/presentation/widgets/text_field_decoration.dart';
import 'package:flutter/material.dart';

class XTextField extends StatelessWidget {
  const XTextField({
    super.key,
    this.initialValue,
    this.enable = true,
    required this.onChanged,
    this.keyboardType,
    this.textInputAction,
    required this.hintText,
    this.maxLines,
    this.suffixIcon,
    this.maxLength,
    this.inputFormatters,
    this.hasShadow = true,
    this.borderColor,
    this.fillColor,
    this.onFieldSubmitted,
    this.textController,
    this.prefixIcon,
    this.errorMessage,
    this.errorTextStyle,
  });

  factory XTextField.showOnly({
    required hintText,
    required suffixIcon,
  }) {
    return XTextField(
        initialValue: null,
        onChanged: null,
        hintText: hintText,
        enable: false,
        suffixIcon: suffixIcon);
  }

  final initialValue;
  final enable;
  final Function(String value)? onChanged;
  final Function(String value)? onFieldSubmitted;
  final hintText;
  final textInputAction;
  final keyboardType;
  final maxLines;
  final suffixIcon;
  final maxLength;
  final inputFormatters;
  final textController;
  final bool hasShadow;
  final Color? borderColor;
  final Color? fillColor;
  final Widget? prefixIcon;
  final String? errorMessage;
  final TextStyle? errorTextStyle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.main,
      initialValue: initialValue,
      controller: textController,
      enabled: enable,
      onChanged: enable == false ? null : (value) => onChanged!(value),
      decoration: getTextFieldDecoration(
          borderRadius: BorderRadius.circular(8),
          hintText: hintText,
          hasShadow: hasShadow,
          borderColor: borderColor,
          suffixIcon: suffixIcon,
          fillColor: fillColor,
          prefixIcon: prefixIcon,
          errorMessage: errorMessage,
          // hintStyle:     textDisplaySmall(color: AppTheme.gray),
          errorStyle: errorTextStyle),
      // style: textDisplaySmall(),
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
