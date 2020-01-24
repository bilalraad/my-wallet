import 'dart:async';

import 'package:flutter/material.dart';

import '../Helpers/size_config.dart';
import '../Helpers/app_localizations.dart';

Future<void> showOverlay({BuildContext context, @required String text})  async {
  final OverlayState overlayState = Overlay.of(context);
  final OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 30.0,
      left: SizeConfig.widthMultiplier * 25,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey.withOpacity(0.25),
        ),
        padding: const EdgeInsets.all(20),
        width: SizeConfig.widthMultiplier * 55,
        child: FittedBox(
          child: Text(
            AppLocalizations.of(context).translate(text),
            style:const TextStyle(
              decorationColor:  Color(0xFFFFFFFF),
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  await Future.delayed(const Duration(seconds: 5));

  overlayEntry.remove();
}
