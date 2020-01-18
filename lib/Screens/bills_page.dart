import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../DB/bills.dart';
import './details_page.dart';
import '../Helpers/styling.dart';
import '../routes/router.gr.dart';
import '../widgets/app_drawer.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/remove_dialog.dart';
import '../Helpers/app_localizations.dart';

class BillsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _textStyle = GoogleFonts.poppins(
      fontSize: 18,
    );

    final translate = AppLocalizations.of(context).translate;
    return WatchBoxBuilder(
      box: Hive.box(H.bills.box()),
      builder: (context, billsBox) {
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
                      final endingDate = bills.bills[i].endingDate == null
                          ? translate('Forever')
                          : DateFormat.yMd().format(bills.bills[i].endingDate);
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => DetailsPage(
                              amount: bills.bills[i].amount,
                              category: bills.bills[i].category,
                              date: bills.bills[i].startingDate,
                              deleteFunction: () => removeDialog(
                                title: translate('Remove this bill?'),
                                context: context,
                              ).then((isAccepted) {
                                if (isAccepted != null && isAccepted as bool) {
                                  bills.deleteBill(bills.bills[i].id);

                                  Navigator.of(context).pop();
                                }
                              }),
                              descripstion: bills.bills[i].description,
                              isDeposit: false,
                            ),
                          ));
                        },
                        onLongPress: () {
                          removeDialog(
                            title: translate('Remove this bill?'),
                            context: context,
                          ).then((isAccepted) {
                            if (isAccepted != null && isAccepted as bool) {
                              bills.deleteBill(bills.bills[i].id);
                            }
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
                                  '${bills.bills[i].amount.toStringAsFixed(2)}\$',
                                  style: _textStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      '${translate("Category")}: ${translate(bills.bills[i].category).toUpperCase()}',
                                      style: _textStyle,
                                    ),
                                    Text(
                                      '|',
                                      style: _textStyle.copyWith(fontSize: 15),
                                    ),
                                    Text(
                                      '${translate('Type')}: ${translate(bills.bills[i].billType.toString())}',
                                      style: _textStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: bills.bills[i].endingDate != null &&
                                        bills.bills[i].endingDate.hour ==
                                            DateTime.now().hour
                                    ? Text(
                                        translate('Expired'),
                                        style: _textStyle,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            '${translate("From")}: ${DateFormat.yMd().format(bills.bills[i].startingDate)}',
                                            style: _textStyle,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${translate("To")}: $endingDate',
                                            style: _textStyle,
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
            onPressed: () {
              Router.navigator.pushNamed(Router.addBill);
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
