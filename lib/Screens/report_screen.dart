import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../DB/transactions.dart';
import '../widgets/app_drawer.dart';
import '../Helpers/size_config.dart';
import '../DB/initialize_HiveDB.dart';
import '../Helpers/get_monthly_data.dart';
import '../Helpers/app_localizations.dart';
import './user_transactions_overview.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final List<Trans> _translist =
      (Hive.box(H.transactions.box()).get(H.transactions.str()) as Transactions)
          .transList;

  int year = DateTime.now().year;

  final List<int> index = getAvailableIndex();

  int monthIndex = getAvailableIndex().last;

  @override
  Widget build(BuildContext context) {
    final _monthlyGroubedTransValues = getMonthlyData(_translist);
    final translate = AppLocalizations.of(context).translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Report')),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            width: SizeConfig.widthMultiplier * 50,
            decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 3),
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<int>(
              isExpanded: true,
              isDense: true,
              underline: Container(),
              value: monthIndex,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              onChanged: (index) {
                setState(() {
                  monthIndex = index;
                  if (index < 4) {
                    year = DateTime.now().year - 1;
                  } else {
                    year = DateTime.now().year;
                  }
                });
              },
              items: index.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    translate(
                      _monthlyGroubedTransValues[value]['month'].toString(),
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TransBarChart(
              transData: _monthlyGroubedTransValues[monthIndex]['transactions']
                  as List<Trans>,
              year: year,
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}

//-------------------------------------
class TransBarChart extends StatefulWidget {
  final int year;
  final List<Trans> transData;

  const TransBarChart({this.year, this.transData});

  @override
  State<StatefulWidget> createState() => TransBarChartState();
}

class TransBarChartState extends State<TransBarChart> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 15;

  List<BarChartGroupData> showingBarGroups;
  double maxY;
  int transactionOfMonth = 0;
  int infolwTransOfMonth = 0;
  int outflowTransOfMonth = 0;

  double getmaxY() {
    //This func. will return the value of week that has the largest income or outcome
    //Also calculating how many transactions in this months and find the
    //how many inflow trans and outflow trans
    double maxy = 0;
    int inTMonth = 0;
    int ouTMonth = 0;
    int transTMonth = 0;

    for (var i = 1; i <= 4; i++) {
      if (maxy < getTheInflowOfTheWeek(i)) {
        maxy = getTheInflowOfTheWeek(i);
      }
      if (maxy < getTheOutOfTheWeek(i)) {
        maxy = getTheOutOfTheWeek(i);
      }
    }

    for (var i in widget.transData) {
      transTMonth++;
      i.isDeposit ? inTMonth++ : ouTMonth++;
    }
    transactionOfMonth = transTMonth;
    infolwTransOfMonth = inTMonth;
    outflowTransOfMonth = ouTMonth;

    return maxy;
  }

  double getTheInflowOfTheWeek(int weeknumber) {
    final int week = weeknumber * 7; //firstweek = 7,second = 14 ...
    double inflow = 0;
    for (var i in widget.transData) {
      if (i.dateTime.year == widget.year &&
          i.dateTime.day <= week &&
          i.dateTime.day >= (weeknumber - 1) * 7) {
        inflow += i.isDeposit ? i.amount : 0;
      }
    }
    return inflow;
  }

  double getTheOutOfTheWeek(int weeknumber) {
    final int week = weeknumber * 7; //firstweek = 7,second = 14 ...
    double outflow = 0;
    for (var i in widget.transData) {
      if (i.dateTime.year == widget.year &&
          i.dateTime.day <= week &&
          i.dateTime.day >= (weeknumber - 1) * 7) {
        outflow += !i.isDeposit ? i.amount : 0;
      }
    }
    return outflow;
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    final barGroup1 =
        makeGroupData(0, getTheInflowOfTheWeek(1), getTheOutOfTheWeek(1));
    final barGroup2 =
        makeGroupData(1, getTheInflowOfTheWeek(2), getTheOutOfTheWeek(2));
    final barGroup3 =
        makeGroupData(2, getTheInflowOfTheWeek(3), getTheOutOfTheWeek(3));
    final barGroup4 =
        makeGroupData(3, getTheInflowOfTheWeek(4), getTheOutOfTheWeek(4));

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
    ];

    showingBarGroups = items;

    maxY = getmaxY();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.deepPurple,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      makeTransactionsIcon(),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        translate('Transactions'),
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(thickness: 3),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        BarChartData(
                          axisTitleData: FlAxisTitleData(
                            bottomTitle: AxisTitle(
                                titleText: translate('Week'),
                                showTitle: true,
                                textStyle: const TextStyle(fontSize: 14)),
                            leftTitle: const AxisTitle(
                              titleText: '',
                              showTitle: true,
                            ),
                            show: true,
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: SideTitles(
                              showTitles: true,
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              margin: 20,
                              getTitles: (double value) {
                                switch (value.toInt()) {
                                  case 0:
                                    return translate('First');
                                  case 1:
                                    return translate('Second');
                                  case 2:
                                    return translate('Third');
                                  case 3:
                                    return translate('Forth');
                                  default:
                                    return '';
                                }
                              },
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              margin: 32,
                              reservedSize: 14,
                              getTitles: (value) {
                                if (value == 0) {
                                  return '0\$';
                                } else if (value >= maxY) {
                                  return '$value';
                                } else if (value == (maxY ~/ 2)) {
                                  return '$value';
                                } else if (value == (maxY ~/ 3)) {
                                  return '$value';
                                } else if (value == (maxY ~/ 6)) {
                                  return '$value';
                                } else if (value == (maxY ~/ 3 + maxY ~/ 2)) {
                                  return '$value';
                                } else if (value == (maxY ~/ 6 + maxY ~/ 2)) {
                                  return '$value';
                                }
                                return '';
                              },
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: showingBarGroups,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: SizeConfig.widthMultiplier * 55,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${translate("Total Transactions")}: $transactionOfMonth',
                softWrap: true,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  Text(
                    '${translate('InFlow')}: $infolwTransOfMonth',
                    style: const TextStyle(color: Colors.green),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${translate("OutFlow")}: $outflowTransOfMonth',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        y: y2,
        color: rightBarColor,
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const double width = 4.5;
    const double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}