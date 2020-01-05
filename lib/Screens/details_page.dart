import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Helpers/size_config.dart';


//this is a generic details Page
class DetailsPage extends StatelessWidget {
  final double amount;
  final String descripstion;
  final String category;
  final DateTime date;
  final Function deleteFunction;
  final bool isDeposit;

  const DetailsPage({
    this.isDeposit = false,
    this.amount,
    this.descripstion,
    this.category,
    this.date,
    this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteFunction,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 25),
        height: SizeConfig.heightMultiplier * 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.category,
                ),
                SizedBox(
                  width: SizeConfig.heightMultiplier * 5,
                ),
                Text(
                  '$category',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.attach_money,
                ),
                SizedBox(
                  width: SizeConfig.heightMultiplier * 5,
                ),
                Text(
                  '${amount.toString()}\$',
                  style: TextStyle(
                    color: isDeposit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w300,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5,
            ),
            Row(
              children: <Widget>[
                Icon(Icons.calendar_today),
                SizedBox(
                  width: SizeConfig.heightMultiplier * 5,
                ),
                Text(
                  date == DateTime.now()
                      ? 'Today'
                      : DateFormat('EEEE, dd/MM/y ').format(date),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Divider(thickness: 3),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1,
            ),
            if (descripstion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Notes:',
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ),
            Text(
              descripstion,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
