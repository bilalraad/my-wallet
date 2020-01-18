import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../DB/app_state.dart';
import '../Helpers/styling.dart';
import './sort_by_category.dart';
import '../DB/transactions.dart';
import '../routes/router.gr.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../widgets/sort_by_trans.dart';
import '../Helpers/app_localizations.dart';

class UserTransactionsTab extends StatelessWidget {
  final Map<String, Object> transactions;
  const UserTransactionsTab(
    this.transactions,
  );

  List<Trans> get _extractedTrans {
    return transactions['transactions'] as List<Trans>;
  }

  void _showModalBottomSheet(
    BuildContext context,
  ) {
    final translate = AppLocalizations.of(context).translate;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: SizeConfig.heightMultiplier * 25,
          decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: Colors.amber,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                onPressed: () {
                  Router.navigator
                      .pushNamed(Router.addTransactions,
                          arguments: false /*IsNotDeposit*/)
                      .then((_) => Navigator.of(context).pop());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_downward,
                      size: 70,
                      color: Colors.red,
                    ),
                    Text(translate('Withdrawal'))
                  ],
                ),
              ),
              RaisedButton(
                color: Colors.amber,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                onPressed: () {
                  Router.navigator
                      .pushNamed(Router.addTransactions,
                          arguments: true /*IsDeposit*/)
                      .then((_) => Navigator.of(context).pop());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_upward,
                      size: 70,
                      color: Colors.green,
                    ),
                    Text(translate('Deposit')),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    return Scaffold(
      body: _extractedTrans == null || _extractedTrans.isEmpty
          ? Center(
              child: Text(translate('There is no Transactions here')),
            )
          : CustomScrollView(
              slivers: <Widget>[
                //First sliver App Bar(Overview card)
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  sliver: SliverAppBar(
                    shape: RoundedRectangleBorder(borderRadius: fifteenCBorder),
                    backgroundColor: const Color(0x0000ffff),
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
                                translate('Overview'),
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2.5),
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                              endIndent: 8,
                              indent: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  translate('InFlow'),
                                  style: const TextStyle(
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
                                  translate('OutFlow'),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  transactions['outFlow'].toString(),
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              indent: 20 * SizeConfig.widthMultiplier,
                              endIndent: 20 * SizeConfig.widthMultiplier,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(translate('Total')),
                                  Text(
                                    transactions['amount'].toString(),
                                  ),
                                ],
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
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 60),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constrains) {
                      return WatchBoxBuilder(
                        box: Hive.box(H.appState.box()),
                        builder: (context, box) {
                          final appState =
                              box.get(H.appState.str()) as AppState;
                          if (appState.filter == PopMenuItem.ByTrans) {
                            return SliverToBoxAdapter(
                              child: ByTransactionType(_extractedTrans),
                            );
                          }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModalBottomSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
