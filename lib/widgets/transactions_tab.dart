import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../DB/app_state.dart';
import '../Helpers/styling.dart';
import './sort_by_category.dart';
import '../DB/transactions.dart';
import '../Screens/add_trans.dart';
import '../Helpers/size_config.dart';
import '../widgets/sort_by_trans.dart';

class UserTransactionsTab extends StatelessWidget {
  final Map<String, Object> transactions;
  UserTransactionsTab(
    this.transactions,
  );

  List<Trans> get _extractedTrans {
    return transactions['transactions'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _extractedTrans == null || _extractedTrans.isEmpty
          ? Center(
              child: Text('There is no Transactions here'),
            )
          : CustomScrollView(
              slivers: <Widget>[
                //First sliver App Bar(Overview card)
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  sliver: SliverAppBar(
                    backgroundColor: Color(1),
                    expandedHeight: 148.0,

                    ///Properties of the App Bar when it is expanded
                    flexibleSpace: FlexibleSpaceBar(
                      background: Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.isPortrait ? 0 : 100),
                        shape: RoundedRectangleBorder(borderRadius: tenCBorder),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Overview',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                              endIndent: 8,
                              indent: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  'Inflow  ',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  transactions['inFlow'].toString(),
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  'Outflow',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  transactions['outFlow'].toString(),
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              indent: 20 * SizeConfig.widthMultiplier,
                              endIndent: 20 * SizeConfig.widthMultiplier,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 150),
                              child: Text(
                                transactions['amount'].toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Transactions cards
                SliverPadding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 60),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constrains) {
                      return WatchBoxBuilder(
                        box: Hive.box('appStateBox'),
                        builder: (context, box) {
                          final appState = box.get('appState') as AppState;
                          if (appState.filter == PopMenuItem.ByTrans)
                            return SliverToBoxAdapter(
                              child: ByTransactionType(_extractedTrans),
                            );
                          // if (selected.filter == PopMenuItem.ByCat)
                          return SliverToBoxAdapter(
                            child: ByCategory(_extractedTrans),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        animatedIcon: AnimatedIcons.menu_close,
        onOpen: () {},
        backgroundColor: Theme.of(context).accentColor,
        children: [
          SpeedDialChild(
            label: 'Withdrawal',
            labelBackgroundColor: Theme.of(context).canvasColor,
            child: Icon(Icons.arrow_downward),
            backgroundColor: Colors.red,
            onTap: () {
              Navigator.of(context).pushNamed(AddTransactions.routName,
                  arguments: false /*IsDeposit*/);
            },
          ),
          SpeedDialChild(
            label: 'Deposit',
            labelBackgroundColor: Theme.of(context).canvasColor,
            child: Icon(Icons.arrow_upward),
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.of(context).pushNamed(AddTransactions.routName,
                  arguments: true /*IsDeposit*/);
            },
          ),
        ],
      ),
    );
  }
}
