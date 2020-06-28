// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mywallet/Screens/user_transactions_overview.dart';
import 'package:mywallet/main.dart';
import 'package:mywallet/Screens/add_trans.dart';
import 'package:mywallet/Screens/add_bill.dart';
import 'package:mywallet/Screens/add_recurring_trans.dart';
import 'package:mywallet/Screens/categories_screen.dart';
import 'package:mywallet/Screens/recurring_tranactions.dart';
import 'package:mywallet/Screens/settings.dart';
import 'package:mywallet/Screens/bills_page.dart';
import 'package:mywallet/Screens/category_select.dart';
import 'package:mywallet/Screens/details_page.dart';
import 'package:mywallet/Screens/intro_screen.dart';
import 'package:mywallet/Screens/add_category.dart';
import 'package:mywallet/Screens/info_sceen.dart';
import 'package:mywallet/Screens/report_screen.dart';

abstract class Routes {
  static const userTransactionsOverView = '/user-transactions-over-view';
  static const wrapper = '/';
  static const addTransactions = '/add-transactions';
  static const addBill = '/add-bill';
  static const addRecurringTransaction = '/add-recurring-transaction';
  static const categoriesScreen = '/categories-screen';
  static const recurringTransactions = '/recurring-transactions';
  static const settings = '/settings';
  static const billsPage = '/bills-page';
  static const categorySelect = '/category-select';
  static const detailsPage = '/details-page';
  static const introductionScreen = '/introduction-screen';
  static const addCategory = '/add-category';
  static const infoSceen = '/info-sceen';
  static const report = '/report';
  static const all = {
    userTransactionsOverView,
    wrapper,
    addTransactions,
    addBill,
    addRecurringTransaction,
    categoriesScreen,
    recurringTransactions,
    settings,
    billsPage,
    categorySelect,
    detailsPage,
    introductionScreen,
    addCategory,
    infoSceen,
    report,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.userTransactionsOverView:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => UserTransactionsOverView(),
          settings: settings,
          title: 'UserTransactionsOverView',
        );
      case Routes.wrapper:
        if (hasInvalidArgs<WrapperArguments>(args)) {
          return misTypedArgsRoute<WrapperArguments>(args);
        }
        final typedArgs = args as WrapperArguments ?? WrapperArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              Wrapper(key: typedArgs.key),
          settings: settings,
        );
      case Routes.addTransactions:
        if (hasInvalidArgs<AddTransactionsArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<AddTransactionsArguments>(args);
        }
        final typedArgs = args as AddTransactionsArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => AddTransactions(isDeposit: typedArgs.isDeposit),
          settings: settings,
        );
      case Routes.addBill:
        return MaterialPageRoute<dynamic>(
          builder: (context) => AddBill(),
          settings: settings,
        );
      case Routes.addRecurringTransaction:
        return MaterialPageRoute<dynamic>(
          builder: (context) => AddRecurringTransaction(),
          settings: settings,
        );
      case Routes.categoriesScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => CategoriesScreen(),
          settings: settings,
          title: 'CategoriesScreen',
        );
      case Routes.recurringTransactions:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => RecurringTransactions(),
          settings: settings,
          title: 'RecurringTransactions',
        );
      case Routes.settings:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => Settings(),
          settings: settings,
          title: 'Settings',
        );
      case Routes.billsPage:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => BillsPage(),
          settings: settings,
          title: 'BillsPage',
        );
      case Routes.categorySelect:
        if (hasInvalidArgs<CategorySelectArguments>(args)) {
          return misTypedArgsRoute<CategorySelectArguments>(args);
        }
        final typedArgs =
            args as CategorySelectArguments ?? CategorySelectArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => CategorySelect(
              onSelectedCategory: typedArgs.onSelectedCategory,
              isDeposit: typedArgs.isDeposit,
              isComingFromAddCat: typedArgs.isComingFromAddCat),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.detailsPage:
        if (hasInvalidArgs<DetailsPageArguments>(args)) {
          return misTypedArgsRoute<DetailsPageArguments>(args);
        }
        final typedArgs =
            args as DetailsPageArguments ?? DetailsPageArguments();
        return CupertinoPageRoute<dynamic>(
          builder: (context) => DetailsPage(
              isDeposit: typedArgs.isDeposit,
              amount: typedArgs.amount,
              descripstion: typedArgs.descripstion,
              category: typedArgs.category,
              date: typedArgs.date,
              deleteFunction: typedArgs.deleteFunction),
          settings: settings,
          title: 'DetailsPage',
        );
      case Routes.introductionScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => IntroductionPage(),
          settings: settings,
          title: 'IntroductionPage',
        );
      case Routes.addCategory:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AddCategory(),
          settings: settings,
        );
      case Routes.infoSceen:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => InfoSceen(),
          settings: settings,
          title: 'InfoSceen',
        );
      case Routes.report:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => Report(),
          settings: settings,
          title: 'ReportScreen',
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//Wrapper arguments holder class
class WrapperArguments {
  final Key key;
  WrapperArguments({this.key});
}

//AddTransactions arguments holder class
class AddTransactionsArguments {
  final bool isDeposit;
  AddTransactionsArguments({@required this.isDeposit});
}

//CategorySelect arguments holder class
class CategorySelectArguments {
  final Function onSelectedCategory;
  final bool isDeposit;
  final bool isComingFromAddCat;
  CategorySelectArguments(
      {this.onSelectedCategory,
      this.isDeposit,
      this.isComingFromAddCat = false});
}

//DetailsPage arguments holder class
class DetailsPageArguments {
  final bool isDeposit;
  final double amount;
  final String descripstion;
  final String category;
  final DateTime date;
  final Function deleteFunction;
  DetailsPageArguments(
      {this.isDeposit = false,
      this.amount,
      this.descripstion,
      this.category,
      this.date,
      this.deleteFunction});
}
