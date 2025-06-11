import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
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
  CardUploadAttachment({super.key,required this.onPressedIcon,required this.icon,required this.image,required this.onPressed,required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: onPressed,
      color: AppColors.light3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      padding:const EdgeInsets.all(0),
      child:  ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
                color: AppColors.dark3,
                dashPattern: const <double>[5, 8],
                radius: const Radius.circular(10),
                strokeWidth: 1,
                borderPadding: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(5),
          ),
          
          child: Container(
            margin:const EdgeInsets.symmetric(vertical: 0,),
            alignment: Alignment.center,
            child: image != null? 
            Container(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image!,fit: BoxFit.cover,height: 110,width: 110,)
                  ),
                  Positioned(
                    top: 10,
                    right: 0,
                    child: Container(
                      height: 30,
                      decoration:const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.light4,
                      ),
                      child: IconButton(
                        padding:const EdgeInsets.all(0),
                        onPressed: onPressedIcon, icon:const Icon(Icons.delete_forever_outlined,size: 18,color: AppColors.red,)
                      ),
                    ),
                  )
                ],
              ),
            )
            :Container(
               margin:const EdgeInsets.symmetric(vertical: 16,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(icon.toString(),width: 35,),
                  const SizedBox(height: 12,),
                  Text(title.toString(),style: ThemeConstands.font14SemiBold,textAlign: TextAlign.center,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}