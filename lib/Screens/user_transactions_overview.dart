import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../DB/app_state.dart';
import '../DB/transactions.dart';
import '../widgets/app_drawer.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../widgets/future_trans_tab.dart';
import '../Helpers/get_monthly_data.dart';
import '../widgets/transactions_tab.dart';
import '../Helpers/app_localizations.dart';

List<int> getAvailableIndex() {
  //This will make sure to display the last 4 months of the last year
  final monthsIndex = DateTime.now().month + 4;

  final List<int> index = [];

  for (int i = 0; i < monthsIndex; i++) {
    index.add(i);
  }

  return index;
}

final AppState _appState =
    Hive.box(H.appState.box()).get(H.appState.str()) as AppState;

class UserTransactionsOverView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentMonthIndex = DateTime.now().month - 1; //0123....11

    final translate = AppLocalizations.of(context).translate;
    return ValueListenableBuilder(
        valueListenable: Hive.box(H.transactions.box()).listenable(),
        builder: (context, transBox, _) {
          final transactions =
              transBox.get(H.transactions.str()) as Transactions;

          final List<Trans> _translist = transactions.transList;

          final _monthlyGroubedTransValues = getMonthlyData(_translist);
          final index = getAvailableIndex().toList();

          return DefaultTabController(
            initialIndex: currentMonthIndex + 4,
            length: index.length + 1,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(SizeConfig.heightMultiplier * 15),
                child: AppBar(
                  bottom: TabBar(
                    isScrollable: true,
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                    tabs: <Widget>[
                      for (final i in index)
                        if (i != (currentMonthIndex + 4))
                          Tab(
                            text: translate(_monthlyGroubedTransValues[i]
                                    ['month']
                                .toString()),
                          ),
                      Tab(
                        text: translate(
                            _monthlyGroubedTransValues[currentMonthIndex + 4]
                                    ['month']
                                .toString()),
                      ),
                      Tab(
                        text: translate('FUTURE'),
                      ),
                    ],
                    labelStyle:
                        TextStyle(fontSize: SizeConfig.textMultiplier * 2),
                  ),
                  centerTitle: true,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        translate('Total'),
                        style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 2,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        '${transactions.total.toStringAsFixed(1)} ${translate(_appState.currency)}',
                        style:
                            TextStyle(fontSize: SizeConfig.textMultiplier * 3),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    PopupMenuButton(
                      onSelected: (PopMenuItem selectedItem) {
                        final appState = Hive.box(H.appState.box())
                            .get(H.appState.str()) as AppState;
                        appState.changeFilter(selectedItem);
                      },
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: PopMenuItem.ByCat,
                          child: Text(
                            translate('View by category'),
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                        ),
                        PopupMenuItem(
                          value: PopMenuItem.ByTrans,
                          child: Text(
                            translate('View by transaction'),
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  for (final i in index)
                    if (i != (currentMonthIndex + 4))
                      UserTransactionsTab(
                        _monthlyGroubedTransValues[i],
                      ),
                  UserTransactionsTab(
                    _monthlyGroubedTransValues[currentMonthIndex+4],
                  ),
                  FutureTransactionsTap(),
                ],
              ),
              drawer: AppDrawer(),
            ),
          );
        });
  }
}
