import 'package:auto_route/auto_route.dart';
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
      body: ValueListenableBuilder(
          valueListenable: Hive.box(H.categories.box()).listenable(),
          builder: (contex, catbox, _) {
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
        heroTag: 'Category_screen',
        onPressed: () {
          ExtendedNavigator.of(context).pushNamed(Routes.addCategory);
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
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
    final textStyle = TextStyle(fontSize: SizeConfig.textMultiplier * 3);
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
              onLongPress: () => removeDialog(
                title: 'Remove this Category?',
                context: context,
              ).then(
                (isAccepted) {
                  if (isAccepted != null && isAccepted as bool) {
                    categories.deleteCategory(
                      categoryName: category.title,
                      isIncome: isIncome,
                    );
                  }
                },
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(
                  translate(category.title),
                  style: textStyle,
                ),
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
                          onLongPress: () => removeDialog(
                            title: 'Remove this sub Category?',
                            context: context,
                          ).then(
                            (isAccepted) {
                              if (isAccepted != null && isAccepted as bool) {
                                categories.deleteCategory(
                                  categoryName: sub,
                                  parentCategoryName: category.title,
                                  isIncome: isIncome,
                                );
                              }
                            },
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 20),
                            child: Text(
                              '- ${translate(sub)}',
                              style: textStyle,
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
        );
      }).toList(),
    );
  }
}
