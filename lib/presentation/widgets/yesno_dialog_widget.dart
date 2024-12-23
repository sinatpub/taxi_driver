import 'package:flutter/material.dart';

Future<void> showYesNoCustomDialog(
    BuildContext context, String title, String description, {required Function() onYes}) {
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
              // primary: Colors.red, // Customize your button color
              // backgroundColor: Colors.red,
              // foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
           ElevatedButton(
            
            style: ElevatedButton.styleFrom(
              // primary: Colors.red, // Customize your button color
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            onPressed: onYes,
            child: const Text('Yes')
            // ?? () {
            //   // Navigator.of(context).pop();
            // },
          ),
        ],
      );
    },
  );
}
