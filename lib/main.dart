import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import './DB/app_state.dart';
import './Helpers/styling.dart';
import './Screens/add_bill.dart';
import './Screens/settings.dart';
import './Screens/add_trans.dart';
import './Screens/bills_page.dart';
import './Helpers/size_config.dart';
import './Screens/intro_screen.dart';
import './DB/initialize_HiveDB.dart';
import './Screens/categories_screen.dart';
import './Screens/add_recurring_trans.dart';
import './Helpers/notificationsPlugin.dart';
import './Screens/recurring_tranactions.dart';
import './Screens/user_transactions_overview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(MyWallet());
}

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  bool isLoading = true;

  @override
  void initState() {
  NotificationsPlugin();
    initHive().then((_) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return isLoading
                ? LoadingScreen()
                : WatchBoxBuilder(
                    box: Hive.box(H.appState.box()),
                    builder: (context, appStateBox) {
                      final AppState appMode =
                          appStateBox.get(H.appState.str());
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        theme: appMode.isDark
                            ? AppTheme.darkTheme
                            : AppTheme.lightTheme,
                        home: appState.firstTime
                            ? IntroductionPage()
                            : WatchBoxBuilder(
                                box: Hive.box(H.transactions.box()),
                                builder: (context, _) =>
                                    UserTransactionsOverView(),
                              ),
                        routes: {
                          AddTransactions.routName: (_) => AddTransactions(),
                          CategoriesScreen.routName: (_) => CategoriesScreen(),
                          BillsPage.routName: (_) => BillsPage(),
                          RecurringTransactions.routName: (_) =>
                              RecurringTransactions(),
                          Settings.routName: (_) => Settings(),
                          AddBill.routName: (_) => AddBill(),
                          AddRecurringTransaction.routName: (_) =>
                              AddRecurringTransaction(),
                        },
                      );
                    },
                  );
          },
        );
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
