// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:mywallet/Screens/user_transactions_overview.dart';
import 'package:mywallet/Screens/add_trans.dart';
import 'package:mywallet/Screens/add_bill.dart';
import 'package:mywallet/Screens/add_recurring_trans.dart';
import 'package:mywallet/Screens/categories_screen.dart';
import 'package:mywallet/Screens/recurring_tranactions.dart';
import 'package:mywallet/Screens/settings.dart';
import 'package:mywallet/Screens/bills_page.dart';
import 'package:mywallet/Screens/category_select.dart';
import 'package:auto_route/transitions_builders.dart';
import 'package:mywallet/Screens/details_page.dart';
import 'package:mywallet/Screens/intro_screen.dart';
import 'package:mywallet/Screens/add_category.dart';
import 'package:mywallet/Screens/info_sceen.dart';

class Router {
  static const userTransactionsOverView = '/user-transactions-over-view';
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
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.userTransactionsOverView:
        return CupertinoPageRoute(
          builder: (_) => UserTransactionsOverView(),
          settings: settings,
        );
      case Router.addTransactions:
        if (hasInvalidArgs<bool>(args, isRequired: true)) {
          return misTypedArgsRoute<bool>(args);
        }
        final typedArgs = args as bool;
        return MaterialPageRoute(
          builder: (_) => AddTransactions(isDeposit: typedArgs),
          settings: settings,
        );
      case Router.addBill:
        return MaterialPageRoute(
          builder: (_) => AddBill(),
          settings: settings,
        );
      case Router.addRecurringTransaction:
        return MaterialPageRoute(
          builder: (_) => AddRecurringTransaction(),
          settings: settings,
        );
      case Router.categoriesScreen:
        return CupertinoPageRoute(
          builder: (_) => CategoriesScreen(),
          settings: settings,
        );
      case Router.recurringTransactions:
        return CupertinoPageRoute(
          builder: (_) => RecurringTransactions(),
          settings: settings,
        );
      case Router.settings:
        return CupertinoPageRoute(
          builder: (_) => Settings(),
          settings: settings,
        );
      case Router.billsPage:
        return CupertinoPageRoute(
          builder: (_) => BillsPage(),
          settings: settings,
        );
      case Router.categorySelect:
        if (hasInvalidArgs<CategorySelectArguments>(args)) {
          return misTypedArgsRoute<CategorySelectArguments>(args);
        }
        final typedArgs =
            args as CategorySelectArguments ?? CategorySelectArguments();
        return PageRouteBuilder(
          pageBuilder: (ctx, animation, secondaryAnimation) => CategorySelect(
              onSelectedCategory: typedArgs.onSelectedCategory,
              isDeposit: typedArgs.isDeposit,
              isComingFromAddCat: typedArgs.isComingFromAddCat),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          transitionDuration: Duration(milliseconds: 500),
          fullscreenDialog: true,
        );
      case Router.detailsPage:
        if (hasInvalidArgs<DetailsPageArguments>(args)) {
          return misTypedArgsRoute<DetailsPageArguments>(args);
        }
        final typedArgs =
            args as DetailsPageArguments ?? DetailsPageArguments();
        return MaterialPageRoute(
          builder: (_) => DetailsPage(
              isDeposit: typedArgs.isDeposit,
              amount: typedArgs.amount,
              descripstion: typedArgs.descripstion,
              category: typedArgs.category,
              date: typedArgs.date,
              deleteFunction: typedArgs.deleteFunction),
          settings: settings,
        );
      case Router.introductionScreen:
        return CupertinoPageRoute(
          builder: (_) => IntroductionPage(),
          settings: settings,
        );
      case Router.addCategory:
        return MaterialPageRoute(
          builder: (_) => AddCategory(),
          settings: settings,
        );
      case Router.infoSceen:
        return CupertinoPageRoute(
          builder: (_) => InfoSceen(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

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
