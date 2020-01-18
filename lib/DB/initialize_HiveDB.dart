import 'package:path_provider/path_provider.dart' as syspath;
import 'package:hive/hive.dart';

import './app_state.dart';
import './bills.dart';
import './categories.dart';
import './transactions.dart';
import '../Helpers/my_timer_class.dart';

enum H {
  appState,
  transactions,
  bills,
  categories,
}

extension HiveBoxes on H {
  String str() {
    return this.toString().substring(2);
    //It will convert for ex. 'H.appSate' to 'appSate' and so on
  }

  String box() {
    return '${this.toString().substring(2)}Box';
    //It will convert for ex. 'H.appSate' to 'appSateBox' and so on
  }
}

Future<void> initHive() async {
  final appDocumentDir = await syspath.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(BillAdapter(), 8);
  Hive.registerAdapter(TransAdapter(), 2);
  Hive.registerAdapter(BillsAdapter(), 7);
  Hive.registerAdapter(CategoryAdapter(), 4);
  Hive.registerAdapter(AppStateAdapter(), 0);
  Hive.registerAdapter(BillTypeAdapter(), 6);
  Hive.registerAdapter(CategoriesAdapter(), 5);
  Hive.registerAdapter(PopMenuItemAdapter(), 9);
  Hive.registerAdapter(TransactionsAdapter(), 1);
  Hive.registerAdapter(FutureTransactionAdapter(), 3);

  final billsBox = await Hive.openBox(H.bills.box());
  final appModeBox = await Hive.openBox(H.appState.box());
  final categoriesBox = await Hive.openBox(H.categories.box());
  final transactionsBox = await Hive.openBox(H.transactions.box());

  if (appModeBox.get(H.appState.str()) == null) {
    appModeBox.put(H.appState.str(), AppState());
  }
    appModeBox.put(H.appState.str(), AppState());

  if (transactionsBox.get(H.transactions.str()) == null) {
    transactionsBox.put(H.transactions.str(), Transactions());
  } else {
    final trans = transactionsBox.get(H.transactions.str()) as Transactions;
    final futureTransList = trans.futureTransList;
    final recurringTransList = trans.recurringTransList;

    // This check is nessesary to reset the timer because if 
    // the app was killed in the backround the timer will Stop 
    // if we need the timer to proceed we have to do it in the cloud (not localy)
    if (futureTransList != null && futureTransList.isNotEmpty) {
      for (int i = 0; i < futureTransList.length; i++) {
        timersList.add(
          MyTimerClass(
            id: futureTransList[i].id,
            timer: setTimer(
              bill: futureTransList[i].costumeBill,
              futureTrans: futureTransList[i],
            ),
          ),
        );
      }
    }
    if (recurringTransList != null && recurringTransList.isNotEmpty) {
      for (int i = 0; i < recurringTransList.length; i++) {
        timersList.add(
          MyTimerClass(
            id: recurringTransList[i].id,
            timer: setTimer(
              bill: recurringTransList[i].costumeBill,
              futureTrans: recurringTransList[i],
            ),
          ),
        );
      }
    }
  }


  if (billsBox.get(H.bills.str()) == null) {
    billsBox.put(H.bills.str(), Bills());
  } else {
    final bills = billsBox.get(H.bills.str()) as Bills;

    for (int i = 0; i < bills.bills.length; i++) {
      timersList.add(
        MyTimerClass(
          id: bills.bills[i].id,
          timer: setTimer(
            bill: bills.bills[i],
            futureTrans: null,
          ),
        ),
      );
    }
  }
    categoriesBox.put(H.categories.str(), Categories());

  if (categoriesBox.get(H.categories.str()) == null) {
    categoriesBox.put(H.categories.str(), Categories());
  }
}
