import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

class XButton extends StatelessWidget {
  final String? toolTip;
  final GestureTapCallback? onPress;
  final GestureTapCallback? onLongPress;
  final Widget child;
  final BorderRadius? borderRadius;
  @override
  final ValueKey<String>? key;
  Color? color;

  XButton({
    this.toolTip,
    required this.onPress,
    required this.child,
    this.borderRadius,
    this.onLongPress,
    this.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: key,
      children: [
        child,
        Positioned.fill(
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            child: Material(
              color: Colors.transparent,
              child: toolTip == null
                  ? InkWell(
                      splashColor: color,
                      focusColor: color,
                      highlightColor: color,
                      overlayColor: WidgetStateColor.resolveWith(
                          (states) => color ?? AppColors.main.withOpacity(.1)),
                      onTap: onPress,
                      onLongPress: onLongPress,
                    )
                  : Tooltip(
                      message: toolTip,
                      child: InkWell(
                        onTap: onPress,
                        onLongPress: onLongPress,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
