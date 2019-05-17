import 'package:flutter/material.dart';

void showOperationFailedAlert(BuildContext context, {VoidCallback retry}) {
  _showAlert(
    context,
    title: 'Warning',
    message: 'An error occurred while performing the operation',
    retry: retry,
  );
}

void _showAlert(
  BuildContext context, {
  @required String title,
  @required String message,
  VoidCallback retry,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          retry != null
              ? FlatButton(
                  child: Text('Retry'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    retry();
                  })
              : null,
        ],
      );
    },
  );
}
