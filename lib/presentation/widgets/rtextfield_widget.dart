import 'package:flutter/material.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';

class RTextFieldWidget extends StatelessWidget {
  final String? hTitle;
  final Color backgroundColor;
  final Color textColor;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const RTextFieldWidget(
      {super.key,
      this.backgroundColor = AppColors.light1,
      this.textColor = Colors.black,
      this.hintText = '',
      this.controller,
      this.onChanged,
      this.hTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hTitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(hTitle!, style: AppTextStyles.body),
          ),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: backgroundColor,
            hintText: hintText,
            hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
