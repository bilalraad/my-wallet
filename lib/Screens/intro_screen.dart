import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:uuid/uuid.dart';

import '../DB/bills.dart';
import '../DB/app_state.dart';
import '../Helpers/styling.dart';
import '../DB/transactions.dart';
import '../widgets/app_drawer.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../Screens/user_transactions_overview.dart';

final AppState appState = Hive.box(H.appState.box()).get(H.appState.str());

enum Worktype {
  Employ,
  Freelancer,
  DailyWorker,
  None,
}

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key key}) : super(key: key);

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  var worktype = Worktype.None;
  bool setSalary = false;
  final _amountController = TextEditingController();
  var _startingDate = DateTime.now();
  var _billType = BillType.Monthly;
  final textFormFieldKey = GlobalKey<FormState>();

  List<PageViewModel> pages() {
    return [
      //this has been folded up
      PageViewModel(
        // title: 'hello',
        titleWidget: Text(
          'Hello',
          style: TextStyle(
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
          'This app was devloped as a task\nto Code for Iraq community',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
      PageViewModel(
        titleWidget: Padding(
          padding: EdgeInsets.only(top: SizeConfig.isPortrait ? 0.0 : 70.0),
          child: Text(
            'Let\'s set your App',
            style: TextStyle(
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
                    'you work as',
                    style: TextStyle(fontSize: 16),
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
                          child: Text(value.toString().substring(9)),
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
                      'Do you wan\'t to set static income?',
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
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
      if (setSalary && worktype != Worktype.None)
        PageViewModel(
          titleWidget: Container(
            margin: EdgeInsets.only(
                top: SizeConfig.isPortrait ? 100 : 0,
                bottom: SizeConfig.isPortrait ? 50 : 10),
            child: Text(
              'Almost Done',
              style: TextStyle(
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
                    'Set static Income',
                    style: TextStyle(
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
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Amount',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              focusedErrorBorder: inputBorder.copyWith(
                                  borderSide: BorderSide(color: Colors.red)),
                              errorBorder: inputBorder.copyWith(
                                  borderSide: BorderSide(color: Colors.red)),
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder.copyWith(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                            ),
                            keyboardType: TextInputType.number,
                            // autovalidate: true,
                            controller: _amountController,
                            validator: (val) {
                              if (double.tryParse(val) == null)
                                return 'Please enter number';
                              if (double.parse(val) <= 0)
                                return 'Please chose bigger number than $val';
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
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
                              child: Text(value.toString().substring(9)),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                  Text(
                    'Starts from',
                  ),
                  Container(
                    width: SizeConfig.widthMultiplier * 75,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: _startingDate.day == DateTime.now().day
                          ? Text('Today')
                          : Text('${DateFormat.yMd().format(_startingDate)}'),
                      onPressed: () {
                        showDatePicker(
                                initialDate: _startingDate,
                                firstDate: DateTime(2019, 12),
                                lastDate: DateTime(2025),
                                context: context)
                            .then(
                          (newDate) {
                            if (newDate == null) newDate = DateTime.now();
                            setState(
                              () {
                                _startingDate = newDate;
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'NOTE: This will set your Salary as recurring Transaction, So you can cancle it when ever you want',
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
      PageViewModel(
        titleWidget: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            'Final Step',
            style: TextStyle(
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
                    'Percentage of saving',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          errorMaxLines: 2, errorStyle: TextStyle(fontSize: 8)),
                      initialValue:
                          appState.percentageOfSaving.toStringAsFixed(0),
                      maxLength: 3,
                      strutStyle:
                          StrutStyle(forceStrutHeight: true, height: 2.3),
                      autovalidate: true,
                      validator: (v) {
                        if (double.tryParse(v) == null) return 'enter number';
                        return null;
                      },
                      onFieldSubmitted: (v) {
                        if (double.tryParse(v) != null)
                          appState.changePercentageOfSaving(double.parse(v));
                        return;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Text(
                    '%',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
            Text(
              'NOTE: This will cut ${appState.percentageOfSaving.toStringAsFixed(0)}% from every new deposit\nand add it to your savings',
              style: TextStyle(color: Theme.of(context).accentColor),
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
        id: Uuid().v4(),
        isDeposit: true,
        isrecurring: true,
        costumeBill: Bill(
          amount: _amount,
          category: 'Salary',
          description: 'This Is My salary',
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
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => UserTransactionsOverView(),
      ),
    );

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
      done: Text('Done'),
      onDone: _oneDone,
      pages: pages(),
    );
  }
}
