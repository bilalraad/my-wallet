import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../DB/app_state.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/app_localizations.dart';


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
    final translate = AppLocalizations.of(context).translate;
    final AppState _appState =
    Hive.box(H.appState.box()).get(H.appState.str()) as AppState;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: ()=> deleteFunction(),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
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
                  '${translate(category)}',
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
                  Icons.account_balance_wallet,
                ),
                SizedBox(
                  width: SizeConfig.heightMultiplier * 5,
                ),
                Text(
                  '${amount.toString()} ${translate(_appState.currency)}',
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
                      ? translate('Today')
                      : DateFormat('dd/MM/y ').format(date),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Divider(thickness: 3),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1,
            ),
            if (descripstion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${translate('Notes')}:',
                  style: const TextStyle(
                    fontSize: 26,
                  ),
                ),
              ),
            Text(
              descripstion,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
