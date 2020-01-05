import 'dart:async';

import 'package:flutter/material.dart';

import '../Helpers/size_config.dart';

showOverlay({BuildContext context, @required String text}) async {
  OverlayState overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 30.0,
      left: SizeConfig.widthMultiplier * 25,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey.withOpacity(0.25),
        ),
        padding: EdgeInsets.all(20),
        width: SizeConfig.widthMultiplier * 55,
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              decorationColor: Color(1),
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  await Future.delayed(Duration(seconds: 5));

  overlayEntry.remove();
}
