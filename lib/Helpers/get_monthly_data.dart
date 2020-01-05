import 'package:intl/intl.dart';

import '../DB/transactions.dart';

// this will put each transaction into its month
// but if the transaction is from last year it will pass it
// TO DO: make some changes so at least return the last 6 months
List<Map<String, Object>> getMonthlyData(List<Trans> trans) {
  if (trans == null) {
    return [];
  }
  return List.generate(
    12,
    (index) {
      final _yearMonth = index + 1;
      final _year = DateTime.now().year;
      List<Trans> _transByMonth = [];
      var _totalSum = 0.0;
      var _inFlow = 0.0;
      var _outFlow = 0.0;
      for (int i = 0; i < trans.length; i++) {
        if (trans[i].dateTime.month == _yearMonth &&
            trans[i].dateTime.year == _year) {
          if (trans[i].isDeposit) {
            _totalSum += trans[i].amount;
            _inFlow += trans[i].amount;
          } else {
            _outFlow += trans[i].amount;
            _totalSum -= trans[i].amount;
          }
          _transByMonth.add(trans[i]);
        }
      }
      return {
        'month': getMonthsName(DateTime(_year, _yearMonth)),
        'amount': _totalSum,
        'inFlow': _inFlow,
        'outFlow': _outFlow,
        'transactions': _transByMonth
      };
    },
  ).toList();
}

String currentMonth() => getMonthsName(DateTime.now());
String getMonthsName(DateTime month) => DateTime.now().month == month.month
    ? 'THIS MONTH'
    : DateFormat.MMMM().format(month);
