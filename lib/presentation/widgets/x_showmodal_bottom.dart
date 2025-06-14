import 'package:flutter/material.dart';

Future xShowModalBottomSheet({
  required BuildContext context,
  bool useRootNavigator = true,
  bool isScrollControlled = true,
  double initialChildSize = 0.7,
  double maxChildSize = 1.0,
  double minChildSize = 0.4,
  Color? backgroundColor,
  bool expand = false,
  required Widget Function(BuildContext, ScrollController) body,
}) async {
  return await showModalBottomSheet(
    context: context,
    useRootNavigator: useRootNavigator,
    useSafeArea: true,
    sheetAnimationStyle: AnimationStyle(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeOut,
    ),
    isScrollControlled: isScrollControlled,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        maxChildSize: maxChildSize,
        minChildSize: minChildSize,
        expand: expand,
        builder: (context, scrollController) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        height: 4,
                        width: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: body(context, scrollController),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
