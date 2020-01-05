import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import './details_page.dart';
import '../DB/transactions.dart';
import '../Helpers/styling.dart';
import '../widgets/app_drawer.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/remove_dialog.dart';
import '../Screens/add_recurring_trans.dart';

class RecurringTransactions extends StatelessWidget {
  static const routName = '/recurring-transactions';

  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
      box: Hive.box(H.transactions.box()),
      builder: (context, transactionsBox) {
        final _transactions =
            transactionsBox.get(H.transactions.str()) as Transactions;
        final rTList = _transactions.recurringTransList;
        return Scaffold(
          appBar: AppBar(
            title: Text('Recurring Transactions'),
          ),
          body: rTList == null || rTList.isEmpty
              ? Center(
                  child: Text('You didn\'t set any Recurring transactions'),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: rTList.length,
                    itemBuilder: (BuildContext context, int i) {
                      final endingDate =
                          rTList[i].costumeBill.endingDate == null
                              ? 'Forever'
                              : DateFormat.yMd()
                                  .format(rTList[i].costumeBill.endingDate);
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => DetailsPage(
                              amount: rTList[i].costumeBill.amount,
                              category: rTList[i].costumeBill.category,
                              date: rTList[i].costumeBill.startingDate,
                              deleteFunction: () => removeDialog(
                                title: 'Remove this recurring transaction?',
                                context: context,
                              ).then((isAccepted) {
                                if (isAccepted != null && isAccepted) {
                                  _transactions.removeFutureTrans(rTList[i]);

                                  Navigator.of(context).pop();
                                }
                              }),
                              descripstion: rTList[i].costumeBill.description,
                              isDeposit: false,
                            ),
                          ));
                        },
                        onLongPress: () {
                          removeDialog(
                            title: 'Remove this recurring transaction?',
                            context: context,
                          ).then((isAccepted) {
                            if (isAccepted != null && isAccepted)
                              _transactions.removeFutureTrans(rTList[i]);
                          });
                        },
                        child: Card(
                          shape:
                              RoundedRectangleBorder(borderRadius: tenCBorder),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${rTList[i].costumeBill.amount.toStringAsFixed(2)}\$',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      'Category: ${rTList[i].costumeBill.category.toUpperCase()}',
                                    ),
                                    Text(
                                      '|',
                                    ),
                                    Text(
                                      'Type: ${rTList[i].costumeBill.billType.toString().substring(9)}',
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: rTList[i].costumeBill.endingDate !=
                                            null &&
                                        rTList[i].costumeBill.endingDate.hour ==
                                            DateTime.now().hour
                                    ? Text(
                                        'Expired',
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            'From: ${DateFormat.yMd().format(rTList[i].costumeBill.startingDate)}',
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'To: $endingDate',
                                          ),
                                        ],
                                      ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          drawer: AppDrawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(AddRecurringTransaction.routName),
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
