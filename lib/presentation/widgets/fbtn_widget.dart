import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';

class FBTNWidget extends StatelessWidget {
  final String label;
  final Color? color;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool enableWidth;
  final double? width;
  final bool? loadingBut;

  const FBTNWidget(
      {super.key,
      required this.label,
      this.color,
      this.textColor = Colors.white,
      required this.onPressed,
      this.enableWidth = false,
      this.width,
      this.loadingBut = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //margin: const EdgeInsets.symmetric(horizontal: 18),
      width: enableWidth ? (width ?? MediaQuery.of(context).size.width) : null,
      height: 42,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstant.padding02)),
        onPressed: onPressed,
        disabledColor: AppColors.light1,
        color: color ?? Theme.of(context).primaryColor,
        textColor: textColor,
        child: loadingBut == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.light4,
                ),
              )
            : Text(
                label,
                style: ThemeConstands.font16SemiBold,
              ),
      ),
    );
  }
}
