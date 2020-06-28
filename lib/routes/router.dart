import 'package:auto_route/auto_route_annotations.dart';
import 'package:mywallet/main.dart';

import '../Screens/add_bill.dart';
import '../Screens/settings.dart';
import '../Screens/add_trans.dart';
import '../Screens/bills_page.dart';
import '../Screens/info_sceen.dart';
import '../Screens/details_page.dart';
import '../Screens/add_category.dart';
import '../Screens/intro_screen.dart';
import '../Screens/report_screen.dart';
import '../Screens/category_select.dart';
import '../Screens/categories_screen.dart';
import '../Screens/add_recurring_trans.dart';
import '../Screens/recurring_tranactions.dart';
import '../Screens/user_transactions_overview.dart';

@CustomAutoRouter()
class $Router {
  @CupertinoRoute(title: 'UserTransactionsOverView')
  UserTransactionsOverView userTransactionsOverView;
  @CupertinoRoute(title: 'Wrapper', initial: true)
  Wrapper wrapper;
  @materialRoute
  AddTransactions addTransactions;
  @materialRoute
  AddBill addBill;
  @materialRoute
  AddRecurringTransaction addRecurringTransaction;
  @CupertinoRoute(title: 'CategoriesScreen')
  CategoriesScreen categoriesScreen;
  @CupertinoRoute(title: 'RecurringTransactions')
  RecurringTransactions recurringTransactions;
  @CupertinoRoute(title: 'Settings')
  Settings settings;
  @CupertinoRoute(title: 'BillsPage')
  BillsPage billsPage;
  @MaterialRoute(fullscreenDialog: true)
  CategorySelect categorySelect;
  @CupertinoRoute(title: 'DetailsPage')
  DetailsPage detailsPage;
  @CupertinoRoute(title: 'IntroductionPage')
  IntroductionPage introductionScreen;
  AddCategory addCategory;
  @CupertinoRoute(title: 'InfoSceen')
  InfoSceen infoSceen;
  @CupertinoRoute(title: 'ReportScreen')
  Report report;
}
