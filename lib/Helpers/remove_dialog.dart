import 'package:flutter/material.dart';

import './styling.dart';
import 'app_localizations.dart';

Future removeDialog({
  BuildContext context,
  String title,
  String content = '',
}) {
      final translate = AppLocalizations.of(context).translate;

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: tenCBorder,
      ),
      title: Text(translate(title)),
      content: content.isEmpty ? null : Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text(translate('No')),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text(translate('Remove')),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    ),
  );
}
