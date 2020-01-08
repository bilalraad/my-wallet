import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../DB/app_state.dart';
import '../DB/transactions.dart';
import '../widgets/app_drawer.dart';
import '../DB/initialize_HiveDB.dart';
import '../widgets/future_trans_tab.dart';
import '../Helpers/get_monthly_data.dart';
import '../widgets/transactions_tab.dart';

List<int> getAvailableIndex() {
  //This will make sure to display the last 4 months of the last year
  var monthsIndex = DateTime.now().month +4; 

  List<int> index = [];

  for (int i = 0; i < monthsIndex; i++) {
    index.add(i);
  }

  return index;
}

class UserTransactionsOverView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currentMonthIndex = DateTime.now().month +3;

    final transactions = Hive.box(H.transactions.box())
        .get(H.transactions.str()) as Transactions;

    final List<Trans> _translist = transactions.transList;

    final _monthlyGroubedTransValues = getMonthlyData(_translist);
    final index = getAvailableIndex().reversed.toList();


    return DefaultTabController(
      initialIndex: currentMonthIndex,
      length: currentMonthIndex+2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
            tabs: <Widget>[
              for (final i in index)
                Tab(
                  text: _monthlyGroubedTransValues[i]['month'],
                ),
              Tab(
                text: 'FUTURE',
              ),
            ],
          ),
          centerTitle: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                '${transactions.total.toStringAsFixed(1)}\$',
                style: TextStyle(fontSize: 25),
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
                  child: Text(
                    'View by category',
                    style: TextStyle(fontSize: 16),
                  ),
                  value: PopMenuItem.ByCat,
                ),
                PopupMenuItem(
                  child: Text(
                    'View by Transaction',
                    style: TextStyle(fontSize: 16),
                  ),
                  value: PopMenuItem.ByTrans,
                ),
              ],
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            for (final i in index)
              UserTransactionsTab(
                _monthlyGroubedTransValues[i],
              ),
            FutureTransactionsTap(),
          ],
        ),
        drawer: AppDrawer(),
      
      ),
    );
  }
}
