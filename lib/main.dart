import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:workmanager/workmanager.dart';

import './DB/app_state.dart';
import './Helpers/styling.dart';
import './routes/router.gr.dart';
import './Helpers/size_config.dart';
import './Screens/intro_screen.dart';
import './DB/initialize_HiveDB.dart';
import './Helpers/app_localizations.dart';
import './Helpers/notificationsPlugin.dart';
import './Screens/user_transactions_overview.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    final notifId = Random();
    final _notificationPlugin = NotificationsPlugin();
    await _notificationPlugin.remindTheUserToOpenTheApp(
      id: notifId.nextInt(100),
      title: qoutes[notifId.nextInt(6)],
      description: '',
    );
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      // isInDebugMode:
      //     true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  Workmanager.registerPeriodicTask(
    'weekly notification',
    'notify the user to open the app each week',
    frequency: const Duration(days: 7),
    initialDelay: const Duration(days: 2),
  );
  runApp(
    MyWallet(),
  );
}

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  bool isLoading = true;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    initHive().then((_) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isLoading == false) checkBillsAndFutureTransactionsList();
          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return isLoading
                  ? LoadingScreen()
                  : ValueListenableBuilder(
                      valueListenable: Hive.box(H.appState.box()).listenable(),
                      builder: (context, appStateBox, _) {
                        final appState =
                            appStateBox.get(H.appState.str()) as AppState;

                        return RestartWidget(
                          child: MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: appState.isDark
                                ? AppTheme.darkTheme
                                : AppTheme.lightTheme,
                            navigatorObservers: [BotToastNavigatorObserver()],
                            // List all of the app's supported locales here
                            supportedLocales: const [
                              Locale('en', 'US'),
                              Locale('ar'),
                            ],
                            // These delegates make sure that the localization data for the proper language is loaded
                            localizationsDelegates: [
                              // A class which loads the translations from JSON files
                              AppLocalizations.delegate,
                              // Built-in localization of basic text for Material widgets
                              GlobalMaterialLocalizations.delegate,
                              // Built-in localization for text direction LTR/RTL
                              GlobalWidgetsLocalizations.delegate,
                            ],
                            // Returns a locale which will be used by the app
                            localeResolutionCallback:
                                (locale, supportedLocales) {
                              final Locale theLocale = appState.myLocale.isEmpty
                                  ? locale
                                  : Locale(appState.myLocale);
                              // Check if the current device locale is supported
                              for (var supportedLocale in supportedLocales) {
                                if (supportedLocale.languageCode ==
                                    locale.languageCode) {
                                  return theLocale;
                                }
                              }
                              // If the locale of the device is not supported, use the first one
                              // from the list (English, in this case).
                              return supportedLocales.first;
                            },
                            home: appState.firstTime
                                ? IntroductionPage()
                                : UserTransactionsOverView(),
                                builder: ExtendedNavigator<Router>(router: Router())

                            // navigatorKey: ,
                          ),
                        );
                      },
                    );
            },
          );
        },
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({this.child});

  final Widget child;

  @override
  _RestartWidgetState createState() => _RestartWidgetState();

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
