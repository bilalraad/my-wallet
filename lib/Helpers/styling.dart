import 'package:flutter/material.dart';

import '../DB/bills.dart';
import './size_config.dart';

final BorderRadius tenCBorder = BorderRadius.circular(10.0);
final BorderRadius fifteenCBorder = BorderRadius.circular(15.0);
final InputBorder inputBorder = OutlineInputBorder(
  borderRadius: tenCBorder,
  borderSide: BorderSide(color: Colors.grey),
);

String getnNameOfBillType(BillType type) {
  switch (type) {
    case BillType.Daily:
      return 'day';
      break;
    case BillType.Weekly:
      return 'week';
      break;
    case BillType.Monthly:
      return 'month';
      break;
    default:
      return 'year';
  }
}

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Color(0xFFFFF7EC);
  static const Color topBarBackgroundColor = Color(0xFFFFD974);
  static const Color selectedTabBackgroundColor = Color(0xFFFFC442);
  static const Color unSelectedTabBackgroundColor = Color(0xFFFFFFFC);
  static const Color subTitleTextColor = Color(0xFF9F988F);
  static const Color accentColor = Colors.purple;
  static const Color primaryColor = Colors.amber;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
    accentColor: Colors.purple,
    primaryColor: Colors.amber,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: darkTextTheme,
    accentColor: Colors.purple,
    primaryColor: Colors.amber,
  );

  static final TextTheme lightTextTheme = TextTheme(
    title: _titleLight,
    subtitle: _subTitleLight,
    button: _buttonLight,
    display1: _greetingLight,
    display2: _searchLight,
    body1: _selectedTabLight,
    body2: _unSelectedTabLight,
    subhead: _subHeadLight,
  );

  static final TextTheme darkTextTheme = TextTheme(
    title: _titleDark,
    subtitle: _subTitleDark,
    button: _buttonDark,
    display1: _greetingDark,
    display2: _searchDark,
    body1: _selectedTabDark,
    body2: _unSelectedTabDark,
    subhead: _subHeadDark,
  );

  static final TextStyle _titleLight = TextStyle(
    color: Colors.black,
    fontSize: 3.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _subTitleLight = TextStyle(
    color: subTitleTextColor,
    fontSize: 2 * SizeConfig.textMultiplier,
    height: 1.5,
  );
  static final TextStyle _subHeadLight = TextStyle(
    color: Colors.black,
    fontSize: 3.2 * SizeConfig.textMultiplier,
  );
  static final TextStyle _subHeadDark =
      _subHeadLight.copyWith(color: Colors.white);

  static final TextStyle _buttonLight = TextStyle(
    color: Colors.black,
    fontSize: 2.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _greetingLight = TextStyle(
    color: Colors.black,
    fontSize: 2.0 * SizeConfig.textMultiplier,
  );

  static final TextStyle _searchLight = TextStyle(
    color: Colors.black,
    fontSize: 2.3 * SizeConfig.textMultiplier,
  );

  static final TextStyle _selectedTabLight = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _unSelectedTabLight = TextStyle(
    color: Colors.grey,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _titleDark = _titleLight.copyWith(color: Colors.white);

  static final TextStyle _subTitleDark =
      _subTitleLight.copyWith(color: Colors.white70);

  static final TextStyle _buttonDark = _buttonLight;

  static final TextStyle _greetingDark = _greetingLight;

  static final TextStyle _searchDark = _searchLight;

  static final TextStyle _selectedTabDark = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _unSelectedTabDark =
      _unSelectedTabLight.copyWith(color: Colors.white70);
}
