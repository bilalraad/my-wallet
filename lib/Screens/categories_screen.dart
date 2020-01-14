import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../DB/categories.dart';
import '../Helpers/styling.dart';
import '../routes/router.gr.dart';
import '../widgets/app_drawer.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/remove_dialog.dart';
import '../Helpers/app_localizations.dart';

class CategoriesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Categories')),
      ),
      body: WatchBoxBuilder(
          box: Hive.box(H.categories.box()),
          builder: (contex, catbox) {
            final categories = catbox.get(H.categories.str()) as Categories;
            final incomeList = categories.incomeList;
            final expenseList = categories.expenseList;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: SizeConfig.isPortrait
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      translate('Income'),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  CategoryListWidget(
                    categoryList: incomeList,
                    isIncome: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      translate('Expense'),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  CategoryListWidget(
                    categoryList: expenseList,
                    isIncome: false,
                  )
                ],
              ),
            );
          }),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Router.navigator.pushNamed(Router.addCategory);
        },
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({
    @required this.categoryList,
    @required this.isIncome,
  });

  final List<Category> categoryList;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final categories =
        Hive.box(H.categories.box()).get(H.categories.str()) as Categories;
    final translate = AppLocalizations.of(context).translate;

    return Column(
      children: categoryList.map((category) {
        return Column(
          crossAxisAlignment: SizeConfig.isPortrait
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.center,
          children: <Widget>[
            //Name of the Main Category
            InkWell(
              borderRadius: fifteenCBorder,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(
                  '${translate(category.title)}',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              onLongPress: () => removeDialog(
                title: translate('Remove this Category?'),
                context: context,
              ).then(
                (isAccepted) {
                  if (isAccepted != null && isAccepted)
                    categories.deleteCategory(
                      categoryName: category.title,
                      parentCategoryName: '',
                      isIncome: isIncome,
                    );
                },
              ),
            ),
            //names of subCategories
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: SizeConfig.isPortrait
                    ? CrossAxisAlignment.stretch
                    : CrossAxisAlignment.center,
                children: category.subCats == null
                    ? <Widget>[]
                    : category.subCats.map((sub) {
                        return InkWell(
                          borderRadius: fifteenCBorder,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 5),
                            child: Text(
                              '${translate(sub)}',
                              style: Theme.of(context).textTheme.subhead,
                            ),
                          ),
                          onLongPress: () => removeDialog(
                            title: translate('Remove this sub Category?'),
                            context: context,
                          ).then(
                            (isAccepted) {
                              if (isAccepted != null && isAccepted)
                                categories.deleteCategory(
                                  categoryName: sub,
                                  parentCategoryName: category.title,
                                  isIncome: isIncome,
                                );
                            },
                          ),
                        );
                      }).toList(),
              ),
            ),
            Divider(
              thickness: 3,
            ),
          ],
        );
      }).toList(),
    );
  }
}
