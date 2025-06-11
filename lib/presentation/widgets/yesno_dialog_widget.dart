import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/core/theme/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<void> showYesNoCustomDialog({required Function() onYes,required BuildContext context,required String title, required String description,}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(description),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
             
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: Text('NO'.tr(),style: ThemeConstands.font16Regular.copyWith(color:AppColors.main,)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
           ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            onPressed: onYes,
            child: Text('YES'.tr(),style: ThemeConstands.font16Regular.copyWith(color:AppColors.light4,))
          ),
        ],
      );
    },
  );
}
