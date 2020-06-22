import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../DB/bills.dart';
import '../DB/transactions.dart';
import '../Helpers/styling.dart';
import '../routes/router.gr.dart';
import '../widgets/app_drawer.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/remove_dialog.dart';
import '../Helpers/my_timer_class.dart';
import '../Helpers/app_localizations.dart';

class RecurringTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;
    final _textStyle = GoogleFonts.poppins(
      fontSize: 15,
    );

    return ValueListenableBuilder(
      valueListenable: Hive.box(H.transactions.box()).listenable(),
      builder: (context, transactionsBox, _) {
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
                      translate("You didn't set any Recurring transactions")),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: rTList.length,
                    itemBuilder: (BuildContext context, int i) {
                      final excuteDate =
                          rTList[i].costumeBill.endingDate == null
                              ? translate('Forever')
                              : DateFormat.yMd()
                                  .format(rTList[i].costumeBill.excuteDate);

                      final daysbeforExcution = DateTime.now()
                              .difference(rTList[i].costumeBill.excuteDate)
                              .inDays
                              .abs() +
                          1;

                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: tenCBorder),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '${translate("Category")}: ',
                                          style: _textStyle.copyWith(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        Text(
                                          translate(translate(rTList[i]
                                                  .costumeBill
                                                  .category)
                                              .toUpperCase()),
                                          style: _textStyle,
                                          textScaleFactor: rTList[i]
                                                      .costumeBill
                                                      .category
                                                      .length >
                                                  14
                                              ? 0.6
                                              : 0.9,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '${translate('Type')}: ',
                                          style: _textStyle.copyWith(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        Text(
                                          translate(rTList[i]
                                              .costumeBill
                                              .billType
                                              .toString()),
                                          style: _textStyle,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      daysbeforExcution == 1
                                          ? translate("Due in Tommorow")
                                          : '${translate("Due in")} $daysbeforExcution ${translate("days")}',
                                      style: _textStyle.copyWith(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                    Text(
                                        '${translate("Repeat till")} $excuteDate')
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        rTList[i]
                                            .costumeBill
                                            .amount
                                            .toStringAsFixed(2),
                                        style: _textStyle,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          color: Colors.red,
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            removeDialog(
                                              title: translate(
                                                  'Remove this recurring transaction?'),
                                              context: context,
                                            ).then((isAccepted) {
                                              if (isAccepted != null &&
                                                  isAccepted as bool) {
                                                _transactions.removeFutureTrans(
                                                    rTList[i]);
                                              }
                                            });
                                          },
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            excuteBill(
                                              futureTrans: rTList[i],
                                              bill: rTList[i]
                                                  .costumeBill
                                                  .updateBill(
                                                    excuteDate: DateTime.now(),
                                                  ),
                                            );
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .backgroundColor,
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                content: Text(
                                                    translate("Done")),
                                              ),
                                            );
                                          },
                                          color: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(translate("Pay")),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          drawer: AppDrawer(),
          floatingActionButton: FloatingActionButton(
            heroTag: 'Recurring_Trans_screen',
            onPressed: () => ExtendedNavigator.of(context)
                .pushNamed(Routes.addRecurringTransaction),
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
