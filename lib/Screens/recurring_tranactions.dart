import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import './details_page.dart';
import '../DB/transactions.dart';
import '../Helpers/styling.dart';
import '../routes/router.gr.dart';
import '../widgets/app_drawer.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/remove_dialog.dart';
import '../Helpers/app_localizations.dart';

class RecurringTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    return WatchBoxBuilder(
      box: Hive.box(H.transactions.box()),
      builder: (context, transactionsBox) {
        final _transactions =
            transactionsBox.get(H.transactions.str()) as Transactions;
        final rTList = _transactions.recurringTransList;
        return Scaffold(
          appBar: AppBar(
            title: Text(translate('Recurring Transactions')),
          ),
          body: rTList == null || rTList.isEmpty
              ? Center(
                  child: Text(
                      translate('You didn\'t set any Recurring transactions')),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: rTList.length,
                    itemBuilder: (BuildContext context, int i) {
                      final endingDate =
                          rTList[i].costumeBill.endingDate == null
                              ? translate('Forever')
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
                                title: translate(
                                    'Remove this recurring transaction?'),
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
                            title:
                                translate('Remove this recurring transaction?'),
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
                                      '${translate("Category")}: ${translate(rTList[i].costumeBill.category).toUpperCase()}',
                                    ),
                                    Text(
                                      '|',
                                    ),
                                    Text(
                                      '${translate("Type")}: ${translate(rTList[i].costumeBill.billType.toString())}',
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
                                        translate('Expired'),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            '${translate("From")}: ${DateFormat.yMd().format(rTList[i].costumeBill.startingDate)}',
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${translate("To")}: $endingDate',
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
            onPressed: () =>
                Router.navigator.pushNamed(Router.addRecurringTransaction),
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
