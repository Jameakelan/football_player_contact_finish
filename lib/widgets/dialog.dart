import 'package:flutter/material.dart';

Future<void> dialogBuilder(
    {required BuildContext context, required VoidCallback onPressYes}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
            'Contact data has changed.\nAre you sure to discard changes?'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              onPressYes();
            },
          ),
        ],
      );
    },
  );
}
