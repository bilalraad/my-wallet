import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Helpers/size_config.dart';
import '../Helpers/app_localizations.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime date;
  final bool isEndingDate;
  final Function setPickedDate;

  const DateTimePicker({
    this.date,
    this.isEndingDate = false,
    this.setPickedDate,
  });

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          translate(!isEndingDate ? 'From' : 'Until'),
          style: TextStyle(fontSize: 3 * SizeConfig.textMultiplier),
        ),
        SizedBox(
          width: 10 * SizeConfig.widthMultiplier,
        ),
        RaisedButton.icon(
          icon: Icon(Icons.calendar_today),
          label: Text(
            date == null
                ? translate('Forever')
                : date.day == DateTime.now().day
                    ? translate('Today')
                    : DateFormat.yMd().format(date),
          ),
          color: Theme.of(context).accentColor,
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2019, 12),
              lastDate: DateTime(2025),
            ).then(
              (pickedValue) {
                if (pickedValue != null) {
                  setPickedDate(
                      isEndingDate: isEndingDate, pickedDate: pickedValue);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
