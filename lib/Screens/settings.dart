import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../main.dart';
import '../DB/app_state.dart';
import '../Helpers/styling.dart';
import '../widgets/app_drawer.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/app_localizations.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    final appState =
        Hive.box(H.appState.box()).get(H.appState.str()) as AppState;

    void _onSelectedLang(String langCode) {
      if (AppLocalizations.of(context).currentLang() != langCode) {
        appState.changeLocale(langCode);
        RestartWidget.restartApp(context);
      } else {
        Navigator.of(context).pop();
      }
    }

    String _currentLang() {
      if (AppLocalizations.of(context).currentLang() == 'ar') {
        return 'Arabic';
      } else {
        return 'English';
      }
    }

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(translate('Settings')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(
                  translate('Percentage of saving'),
                  style: const TextStyle(fontSize: 20),
                ),
                const Spacer(),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        errorMaxLines: 2, errorStyle: TextStyle(fontSize: 8)),
                    initialValue:
                        appState.percentageOfSaving.toStringAsFixed(0),
                    maxLength: 3,
                    strutStyle:
                        const StrutStyle(forceStrutHeight: true, height: 2.3),
                    autovalidate: true,
                    validator: (v) {
                      if (double.tryParse(v) == null) {
                        return translate('enter number');
                      }
                      return null;
                    },
                    onChanged: (v) {
                      if (double.tryParse(v) != null) {
                        appState.changePercentageOfSaving(double.parse(v));
                      }
                      return;
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Text(
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
              style: const TextStyle(fontSize: 15, color: Colors.purple),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${translate("Total savings")}:   ${appState.totalSavingAmount.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 20),
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Theme.of(context).primaryColor,
                  onPressed: appState.totalSavingAmount == 0.0
                      ? null
                      : () {
                          appState.retrieveSaving();
                        },
                  child: Text(translate('Retrieve')),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.language),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${translate('Current language')}: ${translate(_currentLang())}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                FlatButton(
                  color: AppTheme.accentColor,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (_) => SelectLanguage(
                          onSelectedLang: _onSelectedLang,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    translate('Change'),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }
}

class SelectLanguage extends StatelessWidget {
  final Function onSelectedLang;

  const SelectLanguage({@required this.onSelectedLang});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Change App Language')),
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              onSelectedLang('ar');
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.greenAccent,
                child: const Text('AR'),
              ),
              title: Text(translate('Arabic')),
            ),
          ),
          InkWell(
            onTap: () {
              onSelectedLang('en');
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: const Text('EN'),
              ),
              title: const Text('English'),
            ),
          ),
        ],
      ),
    );
  }
}
