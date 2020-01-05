import 'package:flutter/material.dart';

import './styling.dart';

Future removeDialog({
  BuildContext context,
  String title,
  String content = '',
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: tenCBorder,
      ),
      title: Text(title),
      content: content.isEmpty ? null : Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text('Remove'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    ),
  );
}
