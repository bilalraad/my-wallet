import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:uuid/uuid.dart';

import '../DB/bills.dart';
import '../DB/app_state.dart';
import '../Helpers/styling.dart';
import '../DB/transactions.dart';
import '../routes/router.gr.dart';
import '../widgets/app_drawer.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/app_localizations.dart';
import '../widgets/costume_text_form_field.dart';

final AppState appState = Hive.box(H.appState.box()).get(H.appState.str()) as AppState;

enum Worktype {
  Employ,
  Freelancer,
  DailyWorker,
  None,
}

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  Worktype worktype = Worktype.None;
  bool setSalary = false;
  final _amountController = TextEditingController();
  var _startingDate = DateTime.now();
  var _billType = BillType.Monthly;
  final GlobalKey<FormState> textFormFieldKey = GlobalKey<FormState>();

  List<PageViewModel> pages() {
    final translate = AppLocalizations.of(context).translate;
    return [
      //this has been folded up
      PageViewModel(
        titleWidget: Text(
          translate('Hello'),
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        image: Center(
            child: Image.asset(
          'assets/code_for_iraq.png',
          width: 300,
          height: 400,
        )),
        // body: 'lnlkl',
        bodyWidget: Text(
          translate(
              'This app was devloped as a task\nto Code for Iraq community'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      PageViewModel(
        titleWidget: Padding(
          padding: EdgeInsets.only(top: SizeConfig.isPortrait ? 0.0 : 70.0),
          child: Text(
            translate('Let\'s set your App'),
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        image: SizeConfig.isPortrait
            ? Image.asset(
                'assets/gears.png',
                height: 10,
                fit: BoxFit.scaleDown,
              )
            : null,
        bodyWidget: Column(
          children: <Widget>[
            DayNightSwitchWidget(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    translate('you work as'),
                    style: const TextStyle(fontSize: 16),
                  ),
                  DropdownButton<Worktype>(
                    value: worktype,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    onChanged: (Worktype newValue) {
                      setState(() {
                        worktype = newValue;
                      });
                    },
                    items: <Worktype>[
                      Worktype.None,
                      Worktype.Employ,
                      Worktype.Freelancer,
                      Worktype.DailyWorker,
                    ].map<DropdownMenuItem<Worktype>>(
                      (Worktype value) {
                        return DropdownMenuItem<Worktype>(
                          value: value,
                          child: Text(translate(value.toString())),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
            if (worktype != Worktype.None)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      translate('Do you wan\'t to set static income?'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: setSalary,
                      onChanged: (v) {
                        setState(() {
                          setSalary = v;
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      PageViewModel(
        titleWidget: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            translate(setSalary ? 'Almost done' : 'Final Step'),
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        bodyWidget: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    translate('Percentage of saving'),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          errorMaxLines: 2, errorStyle: TextStyle(fontSize: 8)),
                      initialValue:
                          appState.percentageOfSaving.toStringAsFixed(0),
                      maxLength: 3,
                      strutStyle:
                          const StrutStyle(forceStrutHeight: true, height: 2.3),
                      autovalidate: true,
                      validator: (v) {
                        if (double.tryParse(v) == null) return 'enter number';
                        return null;
                      },
                      onChanged: (v) {
                        if (double.tryParse(v) != null) {
                          appState.changePercentageOfSaving(double.parse(v));
                        }
                        return;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const Text(
                    '%',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Text(
              '${translate("NOTE: This will cut")} ${appState.percentageOfSaving.toStringAsFixed(0)}% ${translate("from every new deposit and add it to your savings")}',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ],
        ),
      ),
      if (setSalary && worktype != Worktype.None)
        PageViewModel(
          titleWidget: Container(
            margin: EdgeInsets.only(
                top: SizeConfig.isPortrait ? 100 : 0,
                bottom: SizeConfig.isPortrait ? 50 : 10),
            child: Text(
              translate('Final Step'),
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          bodyWidget: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    translate('Set static Income'),
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    endIndent: 100,
                    indent: 100,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 70,
                        child: Form(
                            key: textFormFieldKey,
                            child: AmountTextFormField(
                              amountController: _amountController,
                            )),
                      ),
                      const SizedBox(
                        width: 80,
                      ),
                      DropdownButton<BillType>(
                        value: _billType,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        onChanged: (BillType newValue) {
                          setState(
                            () {
                              _billType = newValue;
                            },
                          );
                        },
                        items: <BillType>[
                          BillType.Monthly,
                          BillType.Weekly,
                          BillType.Daily,
                          BillType.Yearly,
                        ].map<DropdownMenuItem<BillType>>(
                          (BillType value) {
                            return DropdownMenuItem<BillType>(
                              value: value,
                              child: Text(translate(value.toString())),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                  Text(
                    translate('Starts from'),
                  ),
                  Container(
                    width: SizeConfig.widthMultiplier * 75,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        showDatePicker(
                                initialDate: _startingDate,
                                firstDate: DateTime(2019, 12),
                                lastDate: DateTime(2025),
                                context: context)
                            .then(
                          (newDate) {
                            newDate ??= DateTime.now();
                            setState(
                              () {
                                _startingDate = newDate;
                              },
                            );
                          },
                        );
                      },
                      child: _startingDate.day == DateTime.now().day
                          ? Text(translate('Today'))
                          : Text('${DateFormat.yMd().format(_startingDate)}'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    translate(
                        'NOTE: This will set your Salary as recurring Transaction, So you can cancle it when ever you want'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    ];
  }

  void _oneDone() {
    if (setSalary) {
      final _transactions = Hive.box(H.transactions.box())
          .get(H.transactions.str()) as Transactions;

      if (!textFormFieldKey.currentState.validate()) return;

      int _days;
      final _amount = double.parse(_amountController.text);

      if (_billType == BillType.Monthly) {
        _days = 30;
      } else if (_billType == BillType.Weekly) {
        _days = 7;
      } else if (_billType == BillType.Daily) {
        _days = 1;
      } else {
        _days = 365;
      }

      final _salaryRT = FutureTransaction(
        id: Uuid().v4().toString(),
        isDeposit: true,
        isrecurring: true,
        costumeBill: Bill(
          amount: _amount,
          category: 'Salary',
          description: '',
          billType: BillType.FutureTrans,
          startingDate: _startingDate,
          endingDate: null,
          days: _days,
          id: null,
          remainingDays: _days,
        ),
      );
      _transactions.addFutureTrans(_salaryRT);
    }
    Router.navigator.pushReplacementNamed(Router.userTransactionsOverView);

    appState.firstTime = false;
    Hive.box(H.appState.box()).put(4, appState.firstTime);
    appState.save();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      showNextButton: true,
      next: const Icon(Icons.navigate_next),
      globalBackgroundColor:
          appState.isDark ? Colors.black : AppTheme.appBackgroundColor,
      done: Text(AppLocalizations.of(context).translate('Done')),
      onDone: _oneDone,
      pages: pages(),
    );
  }
}
