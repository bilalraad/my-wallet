import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../DB/categories.dart';
import '../Helpers/styling.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/app_localizations.dart';

class CategorySelect extends StatelessWidget {
  final Function onSelectedCategory;
  final bool isDeposit;
  final bool isComingFromAddCat;
  const CategorySelect({
    this.onSelectedCategory,
    this.isDeposit,
    this.isComingFromAddCat = false,
  });

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    final categories =
        Hive.box(H.categories.box()).get(H.categories.str()) as Categories;

    final categoryList =
        isDeposit ? categories.incomeList : categories.expenseList;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Select Category')),
      ),
      body: ListView.builder(
        itemCount: categoryList.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  borderRadius: fifteenCBorder,
                  onTap: () {
                    onSelectedCategory(categoryList[i].title);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: Text(
                      '${translate(categoryList[i].title)}',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ),
                if (!isComingFromAddCat)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: categoryList[i].subCats == null
                          ? <Widget>[]
                          : categoryList[i].subCats.map((sub) {
                              return InkWell(
                                borderRadius: fifteenCBorder,
                                onTap: () {
                                  onSelectedCategory(sub);
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 5),
                                  child: Text(
                                    translate(sub),
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                              );
                            }).toList(),
                    ),
                  ),
                const Divider(
                  thickness: 3,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
