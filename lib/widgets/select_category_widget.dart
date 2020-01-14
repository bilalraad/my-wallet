import 'package:flutter/material.dart';
import 'package:mywallet/Helpers/app_localizations.dart';

import '../Helpers/styling.dart';
import '../routes/router.gr.dart';
import '../Helpers/size_config.dart';

class SelectCategoryWidget extends StatelessWidget {
  const SelectCategoryWidget({
    this.onSelectedCategory,
    this.categoryName = '',
    this.isIncome,
    this.isComingFromAddcategory = false,
  });

  final String categoryName;
  final bool isIncome;
  final bool isComingFromAddcategory;
  final Function onSelectedCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // padding: EdgeInsets.all(20),
      decoration: BoxDecoration(),
      height: 8 * SizeConfig.heightMultiplier,
      child: InkWell(
          borderRadius: fifteenCBorder,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).accentColor),
              borderRadius: fifteenCBorder,
            ),
            child: Text(
              AppLocalizations.of(context).translate(
                  categoryName == null || categoryName.isEmpty
                      ? isComingFromAddcategory
                          ? 'Parent Category'
                          : 'Select Category'
                      : (categoryName)),
              style: TextStyle(
                fontSize: 4 * SizeConfig.textMultiplier,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          onTap: () => Router.navigator.pushNamed(Router.categorySelect,
              arguments: CategorySelectArguments(
                isDeposit: isIncome,
                isComingFromAddCat: isComingFromAddcategory,
                onSelectedCategory: onSelectedCategory,
              ))),
    );
  }
}
