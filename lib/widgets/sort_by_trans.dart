import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../DB/transactions.dart';
import '../Helpers/styling.dart';
import '../Helpers/size_config.dart';
import '../Screens/details_page.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/remove_dialog.dart';
import '../Helpers/app_localizations.dart';

class ByTransactionType extends StatelessWidget {
  final List<Trans> _trans;
  const ByTransactionType(this._trans);

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
          const SizedBox(
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
  const CardItem({this.trans, this.title});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;
    final textStyle = Theme.of(context)
        .textTheme
        .title
        .copyWith(fontSize: SizeConfig.textMultiplier * 2.0);

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
                    translate(title),
                    style: textStyle,
                  ),
                ),
                const Divider(),
                Column(
                  children: trans
                      .map(
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
                                      if (isAccepted != null &&
                                          isAccepted as bool) {
                                        Hive.box(H.transactions.box())
                                            .get(H.transactions.str())
                                            .deleteTrans(t.id);
                                        Navigator.of(context).pop();
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
                              if (isAccepted != null && isAccepted as bool) {
                                Hive.box(H.transactions.box())
                                    .get(H.transactions.str())
                                    .deleteTrans(t.id);
                              }
                            }),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FittedBox(
                                    child: Text(
                                      translate(t.category),
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 25,
                                    child: FittedBox(
                                      child: Text(
                                        DateFormat(
                                          "d/MM  EEEE",
                                        ).format(t.dateTime),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    t.amount.toString(),
                                    style: textStyle.copyWith(
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
                      )
                      .toList()
                      .reversed
                      .toList(),
                ),
              ],
            ),
          );
  }
}
