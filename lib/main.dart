import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './DB/app_state.dart';
import './Helpers/styling.dart';
import './routes/router.gr.dart';
import './Helpers/size_config.dart';
import './Screens/intro_screen.dart';
import './DB/initialize_HiveDB.dart';
import './Helpers/app_localizations.dart';
import './Screens/user_transactions_overview.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(MyWallet());
}

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  bool isLoading = true;

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
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return isLoading
                ? LoadingScreen()
                : WatchBoxBuilder(
                    box: Hive.box(H.appState.box()),
                    builder: (context, appStateBox) {
                      final AppState appMode =
                          appStateBox.get(H.appState.str());
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        theme: appMode.isDark
                            ? AppTheme.darkTheme
                            : AppTheme.lightTheme,

                        // List all of the app's supported locales here
                        supportedLocales: [
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
                        localeResolutionCallback: (locale, supportedLocales) {
                          // Check if the current device locale is supported
                          for (var supportedLocale in supportedLocales) {
                            if (supportedLocale.languageCode ==
                                locale.languageCode) {
                              return supportedLocale;
                            }
                          }
                          // If the locale of the device is not supported, use the first one
                          // from the list (English, in this case).
                          return supportedLocales.first;
                        },
                        home: appState.firstTime
                            ? IntroductionPage()
                            : UserTransactionsOverView(),

                        onGenerateRoute: Router.onGenerateRoute,

                        navigatorKey: Router.navigatorKey,
                      );
                    },
                  );
          },
        );
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
