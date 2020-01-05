import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './add_bill.dart';
import '../DB/bills.dart';
import './details_page.dart';
import '../Helpers/styling.dart';
import '../widgets/app_drawer.dart';
import '../Helpers/remove_dialog.dart';

class BillsPage extends StatelessWidget {
  static const routName = '/bills-page';

  @override
  Widget build(BuildContext context) {
    final _textStyle = GoogleFonts.poppins(
      fontSize: 18,
    );
    return WatchBoxBuilder(
      box: Hive.box('billsBox'),
      builder: (context, billsBox) {
        final bills = billsBox.get('bills') as Bills;

        return Scaffold(
          appBar: AppBar(
            title: Text('Bills'),
          ),
          body: bills == null || bills.bills.isEmpty
              ? Center(
                  child: Text('You didn\'t set any bills'),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: bills.bills.length,
                    itemBuilder: (BuildContext context, int i) {
                      final endingDate = bills.bills[i].endingDate == null
                          ? 'Forever'
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
                                title: 'Remove this bill?',
                                context: context,
                              ).then((isAccepted) {
                                if (isAccepted != null && isAccepted) {
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
                            title: 'Remove this bill?',
                            context: context,
                          ).then((isAccepted) {
                            if (isAccepted != null && isAccepted)
                              bills.deleteBill(bills.bills[i].id);
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
                                      'Category: ${bills.bills[i].category.toUpperCase()}',
                                      style: _textStyle,
                                    ),
                                    Text(
                                      '|',
                                      style: _textStyle.copyWith(fontSize: 15),
                                    ),
                                    Text(
                                      'Type: ${bills.bills[i].billType.toString().substring(9)}',
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
                                        'Expired',
                                        style: _textStyle,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            'From: ${DateFormat.yMd().format(bills.bills[i].startingDate)}',
                                            style: _textStyle,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'To: $endingDate',
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
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddBill.routName);
            },
          ),
        );
      },
    );
  }
}
