import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../DB/app_state.dart';
import '../widgets/app_drawer.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/app_localizations.dart';

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    final appState =
        Hive.box(H.appState.box()).get(H.appState.str()) as AppState;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(translate('Settings')),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    translate('Percentage of saving'),
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          errorMaxLines: 2, errorStyle: TextStyle(fontSize: 8)),
                      initialValue:
                          appState.percentageOfSaving.toStringAsFixed(0),
                      maxLength: 3,
                      strutStyle:
                          StrutStyle(forceStrutHeight: true, height: 2.3),
                      autovalidate: true,
                      validator: (v) {
                        if (double.tryParse(v) == null)
                          return translate('enter number');
                        return null;
                      },
                      onChanged: (v) {
                        if (double.tryParse(v) != null)
                          appState.changePercentageOfSaving(double.parse(v));
                        return;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Text(
                    '%',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                translate(
                    '${translate('NOTE: This will cut')} ${appState.percentageOfSaving.toStringAsFixed(0)}% ${translate("from every new deposit and add it to your savings")}'),
                style: TextStyle(fontSize: 15, color: Colors.purple),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${translate("Total savings")}:   ${appState.totalSavingAmount.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 20),
                  ),
                  RaisedButton(
                    child: Text(translate('Retrieve')),
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).primaryColor,
                    onPressed: appState.totalSavingAmount == 0.0
                        ? null
                        : () {
                            appState.retrieveSaving();
                          },
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
