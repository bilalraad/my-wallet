import 'package:flutter/material.dart';

import './styling.dart';
import 'app_localizations.dart';
import '../Helpers/size_config.dart';

Future removeDialog({
  BuildContext context,
  String title,
  String content = '',
}) {
  final translate = AppLocalizations.of(context).translate;
  final textStyle = TextStyle(
    fontSize: SizeConfig.textMultiplier * 2.5,
  );

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: tenCBorder,
      ),
      title: Text(
        translate(title),
        style: textStyle,
      ),
      content: content.isEmpty ? null : Text(content),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            translate('No'),
            style: textStyle,
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            translate('Remove'),
            style: textStyle,
          ),
        ),
      ],
    ),
  );
}
