import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:transactions/DB/initialize_HiveDB.dart';

import '../DB/categories.dart';
import '../Helpers/styling.dart';

class CategorySelect extends StatelessWidget {
  static const routName = '/Category-select';
  final Function onSelectedCategory;
  final bool isDeposit;
  final bool isComingFromAddCat;
  CategorySelect(
      [this.onSelectedCategory,
      this.isDeposit,
      this.isComingFromAddCat = false]);

  @override
  Widget build(BuildContext context) {
    final categories =
        Hive.box(H.categories.box()).get(H.categories.str()) as Categories;

    final categoryList =
        isDeposit ? categories.incomeList : categories.expenseList;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
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
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: Text(
                      '${categoryList[i].title}',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  onTap: () {
                    onSelectedCategory(categoryList[i].title);
                    Navigator.of(context).pop();
                  },
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 5),
                                  child: Text(
                                    sub,
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                                onTap: () {
                                  onSelectedCategory(sub);
                                  Navigator.of(context).pop();
                                },
                              );
                            }).toList(),
                    ),
                  ),
                Divider(
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
