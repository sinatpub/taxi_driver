import 'package:flutter/material.dart';
import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/presentation/widgets/expand_section.dart';

class expandCustom extends StatefulWidget {
  bool isExpand;
  bool isClick;
  Widget widget;
  Color colorButtonExpand;
  VoidCallback onPressed;
  Widget childHeader;
  expandCustom({
    Key? key,
    required this.isClick,
    required this.colorButtonExpand,
    required this.widget,
    required this.isExpand,
    required this.childHeader,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<expandCustom> createState() => _expandCustomState();
}

class _expandCustomState extends State<expandCustom>
    with TickerProviderStateMixin {
  late Animation _arrowAnimation;
  late AnimationController _arrowAnimationController;
  final GlobalKey expansionTileKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _arrowAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _arrowAnimation =
        Tween(begin: 0.0, end: 3.14).animate(_arrowAnimationController);
  }

  void _scrollToSelectedContent({required GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: const Duration(milliseconds: 200));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: expansionTileKey,
      decoration: BoxDecoration(
          color: widget.colorButtonExpand,
          border: Border.all(color: AppColors.dark4,width: 0.5),
          borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
            height: 50,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            padding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
              ),
            ),
            onPressed: widget.isClick == true? widget.onPressed:(){},
            child: Container(
              padding: const EdgeInsets.only(
                  left: 18, top: 12, bottom: 12, right: 18),
              child: widget.childHeader,
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(height: 0, color: AppColors.light4),
            secondChild: const SizedBox(),
            crossFadeState: widget.isExpand
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 400),
          ),
          ExpandedSection(expand: widget.isExpand, child: widget.widget),
        ],
      ),
    );
  }
}
