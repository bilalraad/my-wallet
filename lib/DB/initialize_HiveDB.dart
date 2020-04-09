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
    //It will convert 'H.appSate' to 'appSate' and so on
  }

  String box() {
    return '${this.toString().substring(2)}Box';
    //It will convert 'H.appSate' to 'appSateBox' and so on
  }
}

Future<void> initHive() async {
  final appDocumentDir = await syspath.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(BillAdapter());
  Hive.registerAdapter(TransAdapter());
  Hive.registerAdapter(BillsAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(AppStateAdapter());
  Hive.registerAdapter(BillTypeAdapter());
  Hive.registerAdapter(CategoriesAdapter());
  Hive.registerAdapter(PopMenuItemAdapter());
  Hive.registerAdapter(TransactionsAdapter());
  Hive.registerAdapter(FutureTransactionAdapter());

  final billsBox = await Hive.openBox(H.bills.box());
  final appModeBox = await Hive.openBox(H.appState.box());
  final categoriesBox = await Hive.openBox(H.categories.box());
  final transactionsBox = await Hive.openBox(H.transactions.box());

  if (appModeBox.get(H.appState.str()) == null) {
    appModeBox.put(H.appState.str(), AppState());
  }
  if (transactionsBox.get(H.transactions.str()) == null) {
    transactionsBox.put(H.transactions.str(), Transactions());
  } else {}

  if (billsBox.get(H.bills.str()) == null) {
    billsBox.put(H.bills.str(), Bills());
  }

  if (categoriesBox.get(H.categories.str()) == null) {
    categoriesBox.put(H.categories.str(), Categories());
  }
}



//This function will check every bill or recurring trans.
//and excute it if it's due
Future<void> checkBillsAndFutureTransactionsList() async {
  final bills = Hive.box(H.bills.box()).get(H.bills.str()) as Bills;
  final trans =
      Hive.box(H.transactions.box()).get(H.transactions.str()) as Transactions;
  final futureTransList = trans.futureTransList;
  final recurringTransList = trans.recurringTransList;

  for (var bill in bills.bills) {
    delay(
      bill: bill,
      futureTrans: null,
    );
    await Future.delayed(const Duration(seconds: 3));
  }

  if (futureTransList != null && futureTransList.isNotEmpty) {
    for (var ft in futureTransList) {
      delay(
        bill: ft.costumeBill,
        futureTrans: ft,
      );
      await Future.delayed(const Duration(seconds: 3));
    }
  }
  if (recurringTransList != null && recurringTransList.isNotEmpty) {
    for (var rt in recurringTransList) {
      delay(
        bill: rt.costumeBill,
        futureTrans: rt,
      );
      await Future.delayed(const Duration(seconds: 3));
    }
  }
}
