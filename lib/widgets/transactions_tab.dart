import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../DB/app_state.dart';
import '../Helpers/styling.dart';
import '../DB/transactions.dart';
import '../Screens/add_trans.dart';
import '../Helpers/size_config.dart';
import '../Screens/details_page.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/remove_dialog.dart';
import '../widgets/sort_by_trans.dart';

class UserTransactionsTab extends StatelessWidget {
  final Map<String, Object> transactions;
  UserTransactionsTab(
    this.transactions,
  );

  List<Trans> get _extractedTrans {
    return transactions['transactions'];
  }

  Widget buildCard(BuildContext context, Trans trans) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => DetailsPage(
            amount: trans.amount,
            category: trans.category,
            date: trans.dateTime,
            deleteFunction: () => removeDialog(
              title: 'Remove this Transaction?',
              context: context,
            ).then((isAccepted) {
              if (isAccepted != null && isAccepted) {
                Hive.box(H.transactions.box())
                    .get(H.transactions.str())
                    .deleteTrans(trans.id);
                Navigator.of(context).pop();
              }
            }),
            descripstion: trans.description,
            isDeposit: trans.isDeposit,
          ),
        ));
      },
      onLongPress: () => removeDialog(
        title: 'Remove this Transaction?',
        context: context,
      ).then((isAccepted) {
        if (isAccepted != null && isAccepted)
          Hive.box(H.transactions.box())
              .get(H.transactions.str())
              .deleteTrans(trans.id);
      }),
      borderRadius: tenCBorder,
      child: Card(
        margin:
            EdgeInsets.symmetric(horizontal: SizeConfig.isPortrait ? 0 : 100),
        shape: RoundedRectangleBorder(borderRadius: tenCBorder),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
              child: Text(
                '${trans.category}',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(1 * SizeConfig.heightMultiplier),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${DateFormat('D/M/y').format(trans.dateTime)}',
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Text(
                    '${trans.amount} \$',
                    style: TextStyle(
                      color: trans.isDeposit ? Colors.green : Colors.red,
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
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
                            child: Column(
                              children: _extractedTrans.map(
                                (ex) {
                                  _extractedTrans.sort((a, b) =>
                                      a.category.compareTo(b.category));
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: buildCard(context, ex),
                                  );
                                },
                              ).toList(),
                            ),
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
