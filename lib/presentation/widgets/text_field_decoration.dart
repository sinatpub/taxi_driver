import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/presentation/widgets/decorated_input_border.dart';
import 'package:flutter/material.dart';

InputDecoration getTextFieldDecoration({
  String? hintText,
  String? errorMessage,
  TextStyle? hintStyle,
  TextStyle? errorStyle,
  EdgeInsets? contentPadding,
  Widget? suffixIcon,
  VoidCallback? onSuffixIconPress,
  Color? fillColor,
  Color? borderColor,
  BorderRadius? borderRadius,
  bool hasShadow = true,
  bool isShowCounter = false,
  int? maxLength,
  Widget? prefixIcon,
  VoidCallback? onPrefixIconPress,
}) {
  return InputDecoration(
    errorText: errorMessage,
    errorStyle: errorStyle ??
        ThemeConstands.font12Regular.copyWith(color: AppColors.error),
    filled: true,
    fillColor: fillColor ?? Colors.white,
    disabledBorder: getBorder(Colors.transparent,
        hasShadow: hasShadow, borderRadius: borderRadius),
    focusedBorder: getBorder(AppColors.main,
        hasShadow: hasShadow, borderRadius: borderRadius),
    border: getBorder(Colors.transparent,
        hasShadow: hasShadow, borderRadius: borderRadius),
    enabledBorder: getBorder(borderColor ?? Colors.transparent,
        hasShadow: hasShadow, borderRadius: borderRadius),
    focusedErrorBorder:
        getBorder(Colors.red, hasShadow: hasShadow, borderRadius: borderRadius),
    errorBorder:
        getBorder(Colors.red, hasShadow: hasShadow, borderRadius: borderRadius),
    hintText: hintText,
    counter: isShowCounter && maxLength != null ? null : const SizedBox(),
    contentPadding: contentPadding ??
        const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    hintStyle: hintStyle ??
        ThemeConstands.font16Regular.copyWith(color: AppColors.dark2),
    prefixIcon: prefixIcon == null
        ? null
        : ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPrefixIconPress,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: prefixIcon,
                ),
              ),
            ),
          ),
    suffixIcon: suffixIcon == null
        ? null
        : ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSuffixIconPress,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: suffixIcon,
                ),
              ),
            ),
          ),
  );
}

InputBorder getBorder(Color color,
    {bool hasShadow = true, BorderRadius? borderRadius}) {
  final border = OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10.0),
      borderSide: BorderSide(color: color));
  if (!hasShadow) {
    return border;
  }
  return DecoratedInputBorder(
    child: border,
    shadow: const BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0, 2),
        blurRadius: 5),
  );
}
