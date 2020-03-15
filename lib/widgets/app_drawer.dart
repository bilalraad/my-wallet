import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:day_night_switch/day_night_switch.dart';


import '../DB/app_state.dart';
import '../routes/router.gr.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/app_localizations.dart';

int _selectedIndex = 1;

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: SizeConfig.isPortrait ? 130.0 : 50,
              ),
              const SizedBox(
                height: 20,
              ),
              DrawerBotton(
                lable: 'Home',
                icon: Icons.home,
                routeName: Router.userTransactionsOverView,
                index: 1,
              ),
              DrawerBotton(
                lable: 'Categories',
                icon: Icons.category,
                routeName: Router.categoriesScreen,
                index: 2,
              ),
              DrawerBotton(
                lable: 'Bills',
                icon: Icons.receipt,
                routeName: Router.billsPage,
                index: 3,
              ),
              DrawerBotton(
                lable: 'Recurring Transactions',
                icon: Icons.refresh,
                routeName: Router.recurringTransactions,
                index: 4,
              ),
              DrawerBotton(
                lable: 'Report',
                icon: Icons.insert_chart,
                routeName: Router.report,
                index: 5,
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
                            AppLocalizations.of(context)
                                .translate('YourSavings'),
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2.5),
                          ),
                          Text(
                            totalSaving.toStringAsFixed(1),
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2.5),
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
                index: 6,
              ),
              DrawerBotton(
                lable: 'Info',
                icon: Icons.info_outline,
                routeName: Router.infoSceen,
                index: 7,
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
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
      height: SizeConfig.heightMultiplier * 2.6,
      margin: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "App Theme",
            style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.5),
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
  const DrawerBotton(
      {@required this.routeName,
      @required this.lable,
      @required this.icon,
      @required this.index});

  final String lable;
  final String routeName;
  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .title
        .copyWith(fontSize: SizeConfig.textMultiplier * 2.5);

    final isRTL = AppLocalizations.of(context).currentLang() == 'ar';

    final borderRadius = isRTL
        ? const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
          )
        : const BorderRadius.only(
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(20),
          );
    return InkWell(
        borderRadius: borderRadius,
        highlightColor: Colors.amber,
        onTap: () {
          Router.navigator.pushReplacementNamed(routeName);
          _selectedIndex = index;
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color:
                _selectedIndex == index ? Colors.amber.withOpacity(0.5) : null,
          ),
          padding: const EdgeInsets.all(8.0),
          margin: EdgeInsets.only(
            right: !isRTL ? 10 : 0,
            left: isRTL ? 10 : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                size: SizeConfig.imageSizeMultiplier * 5,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                AppLocalizations.of(context).translate(lable),
                style: textStyle,
              ),
            ],
          ),
        ));
  }
}
