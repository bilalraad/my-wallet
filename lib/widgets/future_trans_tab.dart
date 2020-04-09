import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../DB/bills.dart';
import '../DB/transactions.dart';
import '../Helpers/styling.dart';
import '../routes/router.gr.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../Screens/details_page.dart';
import '../Helpers/remove_dialog.dart';
import '../Helpers/app_localizations.dart';

const _textStyle = TextStyle(
  fontSize: 16,
  color: Colors.green,
);

class FutureTransactionsTap extends StatelessWidget {
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
              Container(
                width: SizeConfig.widthMultiplier * 50,
                child: RaisedButton(
                  color: Colors.amber,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  onPressed: () {
                    Router.navigator
                        .pushNamed(Router.addBill)
                        .then((_) => Navigator.of(context).pop());
                  },
                  child: Column(
                    // direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.receipt,
                        size: 70,
                        color: Colors.blue[800],
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(
                          translate('Add Bill'),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: SizeConfig.widthMultiplier * 50,
                child: RaisedButton(
                  color: Colors.amber,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  onPressed: () {
                    Router.navigator
                        .pushNamed(Router.addRecurringTransaction)
                        .then((_) => Navigator.of(context).pop());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.refresh,
                        size: 70,
                        color: Colors.green[600],
                      ),
                      SizedBox(
                        height: 20,
                        child: FittedBox(
                          child: Text(
                            translate('Add recurring transaction'),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildBillsWidget(),
              buildFutureTransWidget(),
              buildRecurringTransWidget(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'FutureTrans_tab',
        backgroundColor: Colors.cyan,
        onPressed: () => _showModalBottomSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget buildRecurringTransWidget() {
  return ValueListenableBuilder(
    valueListenable: Hive.box(H.transactions.box()).listenable(),
    builder: (context, transBox, _) {
      final _transactions = transBox.get(H.transactions.str()) as Transactions;
      final rTList = _transactions.recurringTransList;
      return rTList == null || rTList.isEmpty
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('Recurring Transactions'),
                    style: _textStyle,
                  ),
                ),
                Column(
                  children: rTList.map((rT) {
                    final date =
                        DateFormat('d/M/yy').format(rT.costumeBill.excuteDate);
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (_) => DetailsPage(
                            amount: rT.costumeBill.amount,
                            category: rT.costumeBill.category,
                            date: rT.costumeBill.startingDate,
                            deleteFunction: () => removeDialog(
                              title: 'Remove this recurring transaction?',
                              context: context,
                            ).then((isAccepted) {
                              if (isAccepted != null && isAccepted as bool) {
                                _transactions.removeFutureTrans(rT);

                                Navigator.of(context).pop();
                              }
                            }),
                            descripstion: rT.costumeBill.description,
                            isDeposit: false,
                          ),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: fifteenCBorder),
                          child: ListTileItem(
                            amount: rT.costumeBill.amount,
                            date: date,
                            description: rT.costumeBill.description,
                            category: rT.costumeBill.category,
                            isDeposit: rT.isDeposit,
                            function: () {
                              removeDialog(
                                title: 'Remove this recurring transaction?',
                                context: context,
                              ).then((isAccepted) {
                                if (isAccepted != null && isAccepted as bool) {
                                  _transactions.removeFutureTrans(rT);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
    },
  );
}

Widget buildFutureTransWidget() {
  return ValueListenableBuilder(
    valueListenable: Hive.box(H.transactions.box()).listenable(),
    builder: (context, transBox, _) {
      final _transactions = transBox.get(H.transactions.str()) as Transactions;
      final fTList = _transactions.futureTransList;
      return fTList == null || fTList.isEmpty
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('Future Transactions'),
                    style: _textStyle,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    children: fTList.map((fT) {
                      final date = DateFormat('d/M/yy')
                          .format(fT.costumeBill.excuteDate);
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => DetailsPage(
                              amount: fT.costumeBill.amount,
                              category: fT.costumeBill.category,
                              date: fT.costumeBill.startingDate,
                              deleteFunction: () => removeDialog(
                                title: 'Remove this future transaction?',
                                context: context,
                              ).then((isAccepted) {
                                if (isAccepted != null && isAccepted as bool) {
                                  _transactions.removeFutureTrans(fT);
                                  Navigator.pop(context);
                                }
                              }),
                              descripstion: fT.costumeBill.description,
                              isDeposit: fT.isDeposit,
                            ),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: fifteenCBorder),
                            child: ListTileItem(
                              amount: fT.costumeBill.amount,
                              date: date,
                              description: fT.costumeBill.description,
                              category: fT.costumeBill.category,
                              isDeposit: fT.isDeposit,
                              function: () {
                                removeDialog(
                                  title: 'Remove this future transaction?',
                                  context: context,
                                ).then((isAccepted) {
                                  if (isAccepted != null &&
                                      isAccepted as bool) {
                                    _transactions.removeFutureTrans(fT);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
    },
  );
}

Widget buildBillsWidget() {
  return ValueListenableBuilder(
    valueListenable: Hive.box(H.bills.box()).listenable(),
    builder: (context, billsBox, _) {
      final translate = AppLocalizations.of(context).translate;
      final bills = billsBox.get(H.bills.str()) as Bills;
      final bList = bills.bills;
      return bList == null || bList.isEmpty
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    translate('Bills'),
                    style: _textStyle,
                  ),
                ),
                Column(
                  children: bList.map((bL) {
                    final date = DateFormat('d/M/yy').format(bL.excuteDate);
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (_) => DetailsPage(
                            amount: bL.amount,
                            category: bL.category,
                            date: bL.startingDate,
                            deleteFunction: () => removeDialog(
                              title: translate('Remove this bill?'),
                              context: context,
                            ).then((isAccepted) {
                              if (isAccepted != null && isAccepted as bool) {
                                bills.deleteBill(bL.id);

                                Navigator.of(context).pop();
                              }
                            }),
                            descripstion: bL.description,
                            isDeposit: false,
                          ),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: fifteenCBorder),
                          child: ListTileItem(
                            amount: bL.amount,
                            date: date,
                            description: bL.description,
                            category: bL.category,
                            isDeposit: false,
                            function: () {
                              removeDialog(
                                title: translate('Remove this bill?'),
                                context: context,
                              ).then((isAccepted) {
                                if (isAccepted != null && isAccepted as bool) {
                                  bills.deleteBill(bL.id);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
    },
  );
}

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    @required this.amount,
    @required this.date,
    @required this.category,
    @required this.isDeposit,
    @required this.function,
    this.description = '',
  });
  final String category;
  final bool isDeposit;
  final double amount;
  final String date;
  final String description;
  final Function function;

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: Container(
        width: 80,
        constraints: const BoxConstraints(
          maxWidth: 105,
        ),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 3,
              color: Theme.of(context).accentColor,
            )),
        child: FittedBox(
          child: Text(
            amount.toString(),
            style: TextStyle(
              color: isDeposit ? Colors.green : Colors.red,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      title: Text(
        translate(category),
        style: TextStyle(
            fontSize: SizeConfig.textMultiplier * 2.5,
            fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              isDeposit
                  ? '${translate("This will add")} $amount ${translate("to your wallet at")} $date.'
                  : '${translate("This will cut")} $amount ${translate("from your wallet at")} $date.',
            ),
          ),
          if (description.isNotEmpty)
            Text('${translate("Description")}: $description'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () => function(),
      ),
    );
  }
}
