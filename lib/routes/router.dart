import 'package:auto_route/auto_route_annotations.dart';
import 'package:auto_route/transitions_builders.dart';
import 'package:mywallet/Screens/add_category.dart';
import 'package:mywallet/Screens/info_sceen.dart';

import '../Screens/add_bill.dart';
import '../Screens/settings.dart';
import '../Screens/add_trans.dart';
import '../Screens/bills_page.dart';
import '../Screens/details_page.dart';
import '../Screens/intro_screen.dart';
import '../Screens/category_select.dart';
import '../Screens/categories_screen.dart';
import '../Screens/add_recurring_trans.dart';
import '../Screens/recurring_tranactions.dart';
import '../Screens/user_transactions_overview.dart';

@autoRouter
class $Router {
  @CupertinoRoute()
  @initial
  UserTransactionsOverView userTransactionsOverView;
  AddTransactions addTransactions;
  AddBill addBill;
  AddRecurringTransaction addRecurringTransaction;
  @CupertinoRoute()
  CategoriesScreen categoriesScreen;
  @CupertinoRoute()
  RecurringTransactions recurringTransactions;
  @CupertinoRoute()
  Settings settings;
  @CupertinoRoute()
  BillsPage billsPage;
  @CustomRoute(
    fullscreenDialog: true,
    transitionsBuilder: TransitionsBuilders.slideBottom,
    durationInMilliseconds: 500,
  )
  CategorySelect categorySelect;
  DetailsPage detailsPage;
  @CupertinoRoute()
  IntroductionPage introductionScreen;
  AddCategory addCategory;
  @CupertinoRoute()
  InfoSceen infoSceen;
}
