import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../DB/bills.dart';
import '../DB/transactions.dart';
import '../Helpers/styling.dart';
import '../Screens/add_bill.dart';
import '../DB/initialize_HiveDB.dart';
import '../Screens/details_page.dart';
import '../Helpers/remove_dialog.dart';
import '../Screens/add_recurring_trans.dart';

final _textStyle = TextStyle(
  fontSize: 16,
  color: Colors.yellow,
);

class FutureTransactionsTap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildBillsWidget(),
            buildFutureTransWidget(),
            buildRecurringTransWidget(),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.cyan,
        children: [
          SpeedDialChild(
            label: 'Add Bill',
            labelBackgroundColor: Theme.of(context).canvasColor,
            child: Icon(Icons.arrow_downward),
            backgroundColor: Colors.blue[800],
            onTap: () {
              Navigator.of(context).pushNamed(AddBill.routName);
            },
          ),
          SpeedDialChild(
            label: 'Add recurring transaction',
            labelBackgroundColor: Theme.of(context).canvasColor,
            child: Icon(Icons.arrow_upward),
            backgroundColor: Colors.green[600],
            onTap: () {
              Navigator.of(context).pushNamed(AddRecurringTransaction.routName);
            },
          ),
        ],
      ),
    );
  }
}

Widget buildRecurringTransWidget() {
  return WatchBoxBuilder(
    box: Hive.box(H.transactions.box()),
    builder: (context, transBox) {
      final Transactions _transactions = transBox.get(H.transactions.str());
      final rTList = _transactions.recurringTransList;
      return rTList == null || rTList.isEmpty
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Recurring Transactions',
                    style: _textStyle,
                  ),
                ),
                Column(
                  children: rTList.map((rT) {
                    final date = DateFormat('d/M/yy').format(
                      DateTime.now().add(
                        Duration(days: rT.costumeBill.remainingDays),
                      ),
                    );
                    return InkWell(
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
                              if (isAccepted != null && isAccepted) {
                                _transactions.removeFutureTrans(rT);

                                Navigator.of(context).pop();
                              }
                            }),
                            descripstion: rT.costumeBill.description,
                            isDeposit: false,
                          ),
                        ));
                      },
                      child: ListTileItem(
                        amount: rT.costumeBill.amount,
                        date: date,
                        description: rT.costumeBill.description,
                        category: rT.costumeBill.category,
                        isDeposit: rT.isDeposit,
                        function: () {
                          removeDialog(
                            title: 'remove This recurring transaction?',
                            context: context,
                          ).then((isAccepted) {
                            if (isAccepted != null && isAccepted)
                              _transactions.removeFutureTrans(rT);
                          });
                        },
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
  return WatchBoxBuilder(
    box: Hive.box(H.transactions.box()),
    builder: (context, transBox) {
      final Transactions _transactions = transBox.get(H.transactions.str());
      final fTList = _transactions.futureTransList;
      return fTList == null || fTList.isEmpty
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Future Transactions',
                    style: _textStyle,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    children: fTList.map((fT) {
                      final date = DateFormat('EEEE d/M/yy')
                          .format(fT.costumeBill.startingDate);
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => DetailsPage(
                              amount: fT.costumeBill.amount,
                              category: fT.costumeBill.category,
                              date: fT.costumeBill.startingDate,
                              deleteFunction: () => removeDialog(
                                title: 'Remove this Future transaction?',
                                context: context,
                              ).then((isAccepted) {
                                if (isAccepted != null && isAccepted) {
                                  _transactions.removeFutureTrans(fT);
                                  Navigator.pop(context);
                                }
                              }),
                              descripstion: fT.costumeBill.description,
                              isDeposit: fT.isDeposit,
                            ),
                          ));
                        },
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
                              if (isAccepted != null && isAccepted)
                                _transactions.removeFutureTrans(fT);
                            });
                          },
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
  return WatchBoxBuilder(
    box: Hive.box(H.bills.box()),
    builder: (context, billsBox) {
      final Bills bills = billsBox.get(H.bills.str());
      final bList = bills.bills;
      return bList == null || bList.isEmpty
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Bills',
                    style: _textStyle,
                  ),
                ),
                Container(
                  child: Column(
                    children: bList.map((bL) {
                      final date = DateFormat('EEEE d/M/yy').format(
                        DateTime.now().add(
                          Duration(days: bL.remainingDays),
                        ),
                      );
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => DetailsPage(
                              amount: bL.amount,
                              category: bL.category,
                              date: bL.startingDate,
                              deleteFunction: () => removeDialog(
                                title: 'Remove this bill?',
                                context: context,
                              ).then((isAccepted) {
                                if (isAccepted != null && isAccepted) {
                                  bills.deleteBill(bL.id);

                                  Navigator.of(context).pop();
                                }
                              }),
                              descripstion: bL.description,
                              isDeposit: false,
                            ),
                          ));
                        },
                        child: ListTileItem(
                          amount: bL.amount,
                          date: date,
                          description: bL.description,
                          category: bL.category,
                          isDeposit: false,
                          function: () {
                            removeDialog(
                              title: 'Remove this Bill?',
                              context: context,
                            ).then((isAccepted) {
                              if (isAccepted != null && isAccepted)
                                bills.deleteBill(bL.id);
                            });
                          },
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
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: Container(
        width: 90,
        constraints: BoxConstraints(
          maxWidth: 105,
        ),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: fifteenCBorder,
            border: Border.all(
              color: Theme.of(context).accentColor,
            )),
        child: Text(
          category,
          textAlign: TextAlign.center,
        ),
      ),
      title: Text(
        amount.toString(),
        style: TextStyle(
          color: isDeposit ? Colors.green : Colors.red,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              isDeposit
                  ? 'This will add $amount to your wallet at $date.'
                  : 'This will cut $amount from your wallet at $date.',
              softWrap: true,
            ),
          ),
          Text(description.isEmpty ? '' : 'Description: $description'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: function,
      ),
    );
  }
}
