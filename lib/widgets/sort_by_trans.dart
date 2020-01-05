import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../DB/transactions.dart';
import '../Helpers/styling.dart';
import '../Helpers/size_config.dart';
import '../Screens/details_page.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/remove_dialog.dart';

class ByTransactionType extends StatelessWidget {
  final List<Trans> _trans;
  ByTransactionType(this._trans);

  @override
  Widget build(BuildContext context) {
    final _inFlowList = _trans.where((t) => t.isDeposit).toList();
    final _outFlowList = _trans.where((t) => !t.isDeposit).toList();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CardItem(
            trans: _inFlowList,
            title: 'InFlow',
          ),
          SizedBox(
            height: 8,
          ),
          CardItem(
            title: 'OutFlow',
            trans: _outFlowList,
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final List<Trans> trans;
  final String title;
  CardItem({this.trans, this.title});

  @override
  Widget build(BuildContext context) {
    return trans.isEmpty
        ? Container()
        : Card(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.isPortrait ? 8 : 100),
            shape: RoundedRectangleBorder(borderRadius: tenCBorder),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Divider(),
                Column(
                  children: trans.map(
                    (t) {
                      return InkWell(
                        borderRadius: tenCBorder,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (_) => DetailsPage(
                                amount: t.amount,
                                category: t.category,
                                date: t.dateTime,
                                deleteFunction: () => removeDialog(
                                  title: 'Remove this Transaction?',
                                  context: context,
                                ).then((isAccepted) {
                                  if (isAccepted != null && isAccepted) {
                                    Hive.box(H.transactions.box())
                                        .get(H.transactions.str())
                                        .deleteTrans(t.id);
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).pop();
                                  }
                                }),
                                descripstion: t.description,
                                isDeposit: t.isDeposit,
                              ),
                            ),
                          );
                        },
                        onLongPress: () => removeDialog(
                          title: 'Remove this Transaction?',
                          context: context,
                        ).then((isAccepted) {
                          if (isAccepted != null && isAccepted)
                            Hive.box(H.transactions.box())
                                .get(H.transactions.str())
                                .deleteTrans(t.id);
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 105,
                                child: Text(
                                  t.category,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(fontSize: 16),
                                ),
                              ),
                              Text(
                                DateFormat(
                                  "hh:mm   d/M  EE",
                                ).format(t.dateTime),
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                t.amount.toString(),
                                style:
                                    Theme.of(context).textTheme.title.copyWith(
                                          fontSize: 15,
                                          color: title == 'InFlow'
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          );
  }
}
