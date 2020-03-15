import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../DB/bills.dart';
import '../Helpers/styling.dart';
import '../routes/router.gr.dart';
import '../widgets/app_drawer.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/remove_dialog.dart';
import '../Helpers/my_timer_class.dart';
import '../Helpers/app_localizations.dart';

class BillsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _textStyle = GoogleFonts.poppins(
      fontSize: 15,
    );

    final translate = AppLocalizations.of(context).translate;
    return ValueListenableBuilder(
      valueListenable: Hive.box(H.bills.box()).listenable(),
      builder: (context, billsBox, _) {
        final bills = billsBox.get(H.bills.str()) as Bills;

        return Scaffold(
          appBar: AppBar(
            title: Text(translate('Bills')),
          ),
          body: bills == null || bills.bills.isEmpty
              ? Center(
                  child: Text(translate('You didn\'t set any bills')),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: bills.bills.length,
                    itemBuilder: (BuildContext context, int i) {
                      final excuteDate = bills.bills[i].endingDate == null
                          ? translate('Forever')
                          : DateFormat.yMd().format(bills.bills[i].excuteDate);

                      final daysbeforExcution = DateTime.now()
                              .difference(bills.bills[i].excuteDate)
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
                                          '${translate(bills.bills[i].category).toUpperCase()}',
                                          style: _textStyle,
                                          textScaleFactor:
                                              bills.bills[i].category.length >
                                                      15
                                                  ? 0.6
                                                  : 0.8,
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
                                          '${translate(bills.bills[i].billType.toString())}',
                                          style: _textStyle,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      daysbeforExcution == 1
                                          ? '${translate("Due in Tommorow")}'
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
                                    Text(
                                      '${bills.bills[i].amount.toStringAsFixed(2)}',
                                      style: _textStyle,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          color: Colors.red,
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            removeDialog(
                                              title: translate(
                                                  'Remove this bill?'),
                                              context: context,
                                            ).then((isAccepted) {
                                              if (isAccepted != null &&
                                                  isAccepted as bool) {
                                                bills.deleteBill(
                                                    bills.bills[i].id);
                                              }
                                            });
                                          },
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            excuteBill(
                                              futureTrans: null,
                                              bill: bills.bills[i].updateBill(
                                                  excuteDate: DateTime.now()),
                                            );
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .backgroundColor,
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                content: Text(
                                                    '${translate("Done")}'),
                                              ),
                                            );
                                          },
                                          color: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child:
                                              Text('${translate("Pay")}'),
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
            onPressed: () {
              Router.navigator.pushNamed(Router.addBill);
            },
            heroTag: 'Bills_screen',
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
