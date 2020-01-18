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
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(translate('No')),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(translate('Remove')),
        ),
      ],
    ),
  );
}
