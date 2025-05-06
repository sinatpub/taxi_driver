import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/resources/asset_resource.dart';

class TImageWidget extends StatelessWidget {
  final ImageProvider? image;
  final BoxFit fit; // Optional fit for the image
  final double? width; // Optional width
  final double? height; // Optional height

  const TImageWidget({
    super.key,
    this.image,
    this.fit = BoxFit.cover, // Default BoxFit
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return image != null
        ? FadeInImage(
            placeholder:const AssetImage(ImageAssets.placeholder_image),
            image: image!,
            fit: fit,
            width: width ?? 30,
            height: height ?? 30,
            imageErrorBuilder: (context, error, stackTrace) {
              return SvgPicture.asset(ImageAssets.no_image,
                width: width,
                height: height,
                fit: BoxFit.contain,
              );
            },
          )
        : SvgPicture.asset(ImageAssets.no_image,
            width: width ?? 30,
            height: height ?? 30,
            fit: BoxFit.contain,
          );
  }
}
