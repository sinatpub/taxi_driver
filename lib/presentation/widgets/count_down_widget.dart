import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/presentation/screens/nav_screen.dart';
import 'package:flutter/material.dart';

class SmoothCircularCountdown extends StatefulWidget {
  final int countDuration;
  final bool isPop;

  const SmoothCircularCountdown(
      {super.key, required this.countDuration, required this.isPop});

  @override
  // ignore: library_private_types_in_public_api
  _SmoothCircularCountdownState createState() =>
      _SmoothCircularCountdownState();
}

class _SmoothCircularCountdownState extends State<SmoothCircularCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.countDuration,
      ), // Countdown duration
    );
    _controller.addListener(() {
      if (_controller.isDismissed && widget.isPop) {
        Navigator.pushAndRemoveUntil(context,PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>  NavScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),(route) => false,
        ); // Pop the screen when countdown finishes
      }
    });
    _controller.reverse(from: 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get timerString {
    Duration countdown = _controller.duration! * _controller.value;
    return '${countdown.inSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.white,
                ),
                child: CircularProgressIndicator(
                  value: _controller.value, // Progress decreases from 1 to 0
                  strokeWidth: 4,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.main),
                  backgroundColor: Colors.grey[300]!,
                ),
              ),
              Column(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: AppColors.main,
                  ),
                  Text(
                    timerString,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "seconds",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
