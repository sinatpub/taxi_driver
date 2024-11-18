import 'package:flutter/material.dart';
import 'package:com.tara_driver_application/presentation/widgets/rtextfield_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RTextFieldWidget(
            hTitle: 'Name',
          ),
          RTextFieldWidget(
            hTitle: 'Phone',
          ),
          RTextFieldWidget(
            hTitle: 'Gender',
          ),
          RTextFieldWidget(
            hTitle: 'Address',
          ),
        ],
      ),
    );
  }
}
