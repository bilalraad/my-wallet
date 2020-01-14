import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import './initialize_HiveDB.dart';

part 'categories.g.dart';

// category model
@HiveType()
class Category {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final List<String> subCats;

  const Category({
    @required this.id,
    @required this.title,
    this.subCats,
  });
}

final Categories _categories = Hive.box(H.categories.box()).get(H.categories.str());

@HiveType()
class Categories extends HiveObject {
  @HiveField(0)
  List<Category> incomeList = [
    Category(
      id: 'salary',
      title: 'Salary',
      subCats: [],
    ),
    Category(
      id: 'gifts',
      title: 'Gifts',
      subCats: [],
    ),
    Category(
      id: 'selling',
      title: 'Selling',
      subCats: [],
    ),
    Category(
      id: 'others',
      title: 'Others',
      subCats: [],
    ),
  ];
  @HiveField(1)
  List<Category> expenseList = [
    Category(
      id: 'food',
      title: 'Food',
      subCats: ['Resturants', 'Cafe'],
    ),
    Category(
      id: 'bills',
      title: 'Bills',
      subCats: ['Phone', 'Electricity'],
    ),
    Category(
      id: 'shoping',
      title: 'Shoping',
      subCats: ['Clothing'],
    ),
    Category(
      id: 'entertainment',
      title: 'Entertainment',
      subCats: ['Movies', 'Games'],
    ),
    Category(
      id: 'travel',
      title: 'Travel',
      subCats: [],
    ),
    Category(
      id: 'donations',
      title: 'Donations',
      subCats: ['Charity', 'Zakat'],
    ),
    Category(
      id: 'family',
      title: 'Family',
      subCats: ['Childrens', 'Home improvments'],
    ),
    Category(
      id: 'education',
      title: 'Education',
      subCats: ['Books'],
    ),
    Category(
      id: 'others',
      title: 'Others',
      subCats: [],
    ),
  ];

  void addCategory([
    String categoryName,
    String parentCategoryName = '',
    bool isIncome,
  ]) {
    incomeList = _categories.incomeList;
    expenseList = _categories.expenseList;
    if (parentCategoryName.isEmpty) {
      final newCategory = Category(
        id: DateTime.now().toString(),
        title: categoryName,
        subCats: null,
      );
      if (isIncome) {
        incomeList.add(newCategory);
      } else {
        expenseList.add(newCategory);
      }
    } else {
      if (isIncome) {
        incomeList.forEach(
          (c) {
            if (c.title == parentCategoryName) {
              c.subCats.add(categoryName);
            }
          },
        );
      } else {
        expenseList.forEach(
          (c) {
            if (c.title == parentCategoryName) {
              c.subCats.add(categoryName);
            }
          },
        );
      }
    }

    Hive.box(H.categories.box()).put(0, incomeList);
    Hive.box(H.categories.box()).put(1, expenseList);
    _categories.save();
  }

  void deleteCategory({
    String categoryName,
    String parentCategoryName = '',
    bool isIncome,
  }) {
    incomeList = _categories.incomeList;
    expenseList = _categories.expenseList;
    if (parentCategoryName.isEmpty) {
      if (isIncome) {
        incomeList.removeWhere((c) => c.title == categoryName);
      } else {
        expenseList.removeWhere((c) => c.title == categoryName);
      }
    } else {
      if (isIncome) {
        incomeList.forEach(
          (c) {
            if (c.title == parentCategoryName) {
              c.subCats.removeWhere((name) => name == categoryName);
            }
          },
        );
      } else {
        expenseList.forEach(
          (c) {
            if (c.title == parentCategoryName) {
              c.subCats.removeWhere((name) => name == categoryName);
            }
          },
        );
      }
    }

    Hive.box(H.categories.box()).put(0, incomeList);
    Hive.box(H.categories.box()).put(1, expenseList);
    _categories.save();
  }
}
