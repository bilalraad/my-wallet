import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../DB/transactions.dart';
import '../Helpers/styling.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../Screens/details_page.dart';
import '../Helpers/remove_dialog.dart';
import '../Helpers/app_localizations.dart';

class ByCategory extends StatelessWidget {
  final List<Trans> extractedTrans;

  const ByCategory(this.extractedTrans);
  
  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;
extractedTrans.sort((a, b) => a.category.compareTo(b.category));
    return Column(
      children: extractedTrans.map(
        (ex) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => DetailsPage(
                    amount: ex.amount,
                    category: ex.category,
                    date: ex.dateTime,
                    deleteFunction: () => removeDialog(
                      title:'Remove this Transaction?',
                      context: context,
                    ).then((isAccepted) {
                      if (isAccepted != null && isAccepted as bool) {
                        Hive.box(H.transactions.box())
                            .get(H.transactions.str())
                            .deleteTrans(ex.id);
                        Navigator.of(context).pop();
                      }
                    }),
                    descripstion: ex.description,
                    isDeposit: ex.isDeposit,
                  ),
                ));
              },
              onLongPress: () => removeDialog(
                title: 'Remove this Transaction?',
                context: context,
              ).then((isAccepted) {
                if (isAccepted != null && isAccepted as bool) {
                  Hive.box(H.transactions.box())
                      .get(H.transactions.str())
                      .deleteTrans(ex.id);
                }
              }),
              borderRadius: tenCBorder,
              child: Card(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.isPortrait ? 0 : 100),
                shape: RoundedRectangleBorder(borderRadius: tenCBorder),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.all(2 * SizeConfig.heightMultiplier),
                      child: Text(
                        translate(ex.category),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding:
                          EdgeInsets.all(1 * SizeConfig.heightMultiplier),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            DateFormat('dd/M/y').format(ex.dateTime),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            '${ex.amount} \$',
                            style: TextStyle(
                              color: ex.isDeposit ? Colors.green : Colors.red,
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
