import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:day_night_switch/day_night_switch.dart';

import '../DB/app_state.dart';
import '../routes/router.gr.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) => Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: SizeConfig.isPortrait ? 130.0 : 50,
            ),
            const SizedBox(
              height: 20,
            ),
            DrawerBotton(
              lable: 'Home',
              icon: Icons.home,
              routeName: Router.userTransactionsOverView,
            ),
            DrawerBotton(
              lable: 'Categories',
              icon: Icons.category,
              routeName: Router.categoriesScreen,
            ),
            DrawerBotton(
              lable: 'Bills',
              icon: Icons.receipt,
              routeName: Router.billsPage,
            ),
            DrawerBotton(
              lable: 'Recurring Transactions',
              icon: Icons.refresh,
              routeName: Router.recurringTransactions,
            ),
            const Divider(),
            DayNightSwitchWidget(),
            ValueListenableBuilder(
                valueListenable: Hive.box(H.appState.box()).listenable(),
                builder: (_, sBox, __) {
                  final totalSaving =
                      sBox.get(H.appState.str()).totalSavingAmount as double;
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('YourSavings'),
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          totalSaving.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }),
            const Spacer(),
            DrawerBotton(
              lable: 'Settings',
              icon: Icons.settings,
              routeName: Router.settings,
            ),
            DrawerBotton(
              lable: 'Info',
              icon: Icons.info_outline,
              routeName: Router.infoSceen,
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class DayNightSwitchWidget extends StatefulWidget {
  @override
  _DayNightSwitchWidgetState createState() => _DayNightSwitchWidgetState();
}

class _DayNightSwitchWidgetState extends State<DayNightSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    final appState =
        Hive.box(H.appState.box()).get(H.appState.str()) as AppState;

    return Container(
      height: 18,
      margin: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            "App Theme",
            style: TextStyle(fontSize: 16),
          ),
          FittedBox(
            fit: BoxFit.cover,
            child: DayNightSwitch(
              value: appState.isDark,
              onChanged: (val) {
                setState(() {
                  appState.setMode(isDark: val);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerBotton extends StatelessWidget {
  const DrawerBotton({
    this.routeName,
    this.lable,
    this.icon,
  });

  final String lable;
  final String routeName;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: AppLocalizations.of(context).currentLang() == 'ar'
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(20),
              )
            : const BorderRadius.only(
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
        focusColor: Colors.amber,
        onTap: () => Router.navigator.pushReplacementNamed(routeName),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                size: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                AppLocalizations.of(context).translate(lable),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ));
  }
}
