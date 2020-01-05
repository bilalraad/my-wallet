import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Helpers/size_config.dart';

class DateTimePicker extends StatelessWidget {
  final BuildContext context;
  final DateTime date;
  final bool isEndingDate;
  final Function setPickedDate;

  const DateTimePicker({
    this.context,
    this.date,
    this.isEndingDate = false,
    this.setPickedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            !isEndingDate ? 'From' : 'Until',
            style: TextStyle(fontSize: 3 * SizeConfig.textMultiplier),
          ),
          SizedBox(
            width: 10 * SizeConfig.widthMultiplier,
          ),
          RaisedButton.icon(
            icon: Icon(Icons.calendar_today),
            label: Text(
              date == null
                  ? 'Forever'
                  : date.day == DateTime.now().day
                      ? 'Today'
                      : '${DateFormat.yMd().format(date)}',
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: date == null ? DateTime.now() : date,
                firstDate: DateTime(2019, 12),
                lastDate: DateTime(2025),
              ).then(
                (pickedValue) {
                  if (pickedValue != null)
                    setPickedDate(isEndingDate, pickedValue);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
