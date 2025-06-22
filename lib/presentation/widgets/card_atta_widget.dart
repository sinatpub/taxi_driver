import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/core/theme/text_styles.dart';

class CardUploadAttachment extends StatelessWidget {
  VoidCallback? onPressed;
  VoidCallback? onPressedIcon;
  String? icon;
  String? title;
  File? image;
  CardUploadAttachment(
      {super.key,
      required this.onPressedIcon,
      required this.icon,
      required this.image,
      required this.onPressed,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: onPressed,
      color: AppColors.light3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: 120,
          margin: const EdgeInsets.symmetric(
            vertical: 0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.dark1),
          ),
          alignment: Alignment.center,
          child: image != null
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.light4,
                        ),
                        child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: onPressedIcon,
                            icon: const Icon(
                              Icons.delete_forever_outlined,
                              size: 18,
                              color: AppColors.red,
                            )),
                      ),
                    )
                  ],
                )
              : Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "$icon",
                        width: 54,
                        colorFilter: const ColorFilter.mode(
                            AppColors.dark4, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        title.toString(),
                        style: ThemeConstands.font14SemiBold,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
