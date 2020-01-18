import 'package:hive/hive.dart';

import './transactions.dart';
import './initialize_HiveDB.dart';

part 'app_state.g.dart';

// Probably it's more convenient to use shared_prefs for
// this kind of data(I mean "isDark" and the filter ) but i didn't 🙂

@HiveType()
enum PopMenuItem {
  @HiveField(0)
  ByCat,
  @HiveField(1)
  ByTrans,
}

final _appState = Hive.box(H.appState.box()).get(H.appState.str()) as AppState;

@HiveType()
class AppState extends HiveObject {
  @HiveField(0)
  bool _isDark = false;

  @HiveField(1)
  PopMenuItem filter = PopMenuItem.ByTrans;

  @HiveField(2)
  double percentageOfSaving = 0.0;

  @HiveField(3)
  double totalSavingAmount = 0.0;

  @HiveField(4)
  bool firstTime = true;

  @HiveField(5)
  String myLocale = '';

  void retrieveSaving() {
    final _tx = Hive.box(H.transactions.box()).get(H.transactions.str())
        as Transactions;

    _tx.total += _appState.totalSavingAmount;
    Hive.box(H.transactions.box()).put(0, _tx.total);
    _tx.save();
    _appState.totalSavingAmount = 0.0;
    Hive.box(H.appState.box()).put(3, _appState.totalSavingAmount);
    _appState.save();
  }

  void changePercentageOfSaving(double newpercentage) {
    _appState.percentageOfSaving = newpercentage;

    Hive.box(H.appState.box()).put(2, _appState.percentageOfSaving);
    _appState.save();
  }

  bool get isDark {
    return _isDark;
  }

  void setMode({bool isDark}) {
    _isDark = isDark;
    Hive.box(H.appState.box()).put(0, _isDark);
    _appState.save();
  }

  void changeFilter(PopMenuItem newFilter) {
    _appState.filter = newFilter;
    Hive.box(H.appState.box()).put(1, _appState.filter);
    _appState.save();
  }

  void changeLocale(String newLocale) {
    _appState.myLocale = newLocale;
    Hive.box(H.appState.box()).put(5, _appState.myLocale);
    _appState.save();
  }
}

extension SavingExtentions on double {
  double getValueOfSaving() {
    final percentageOfSaving = _appState.percentageOfSaving;
    return this * (percentageOfSaving * 0.01);
  }

  //you first have to get the value of saving then use this extenstion below
  //For ex. => valueofsaving = amount.getValueOfSaving()
  //then valueofsaving.addToSavingTotal()
  void addToSavingTotal() {
    _appState.totalSavingAmount += this;
    Hive.box('appStateBox').put(3, _appState.totalSavingAmount);
    _appState.save();
  }
}
