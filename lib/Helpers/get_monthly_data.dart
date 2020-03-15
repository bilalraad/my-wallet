import 'package:intl/intl.dart';

import '../DB/transactions.dart';

// this will put each transaction into its month
List<Map<String, Object>> getMonthlyData(List<Trans> trans) {
  //This will make sure to add the last 4 months of the last year
  final currentMonth = DateTime.now().month;
  final length = currentMonth + 4;
  var countDouwn = 0;

  return List.generate(
    length,
    (index) {
      // This check will first give me the last 4 months of the last year 
      // then it will jump to the current year
      final _month = index >= 4 ? index - 3 : (9+ countDouwn++);
      final _currentYear = DateTime.now().year;
      final _year = index >= 4 ? _currentYear : _currentYear - 1;

      final List<Trans> _transByMonth = [];
      var _totalSum = 0.0;
      var _inFlow = 0.0;
      var _outFlow = 0.0;
      for (int i = 0; i < trans.length; i++) {
        if (trans[i].dateTime.month == _month &&
            (trans[i].dateTime.year == _year)) {
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
        'month': getMonthsName(DateTime(_year, _month)),
        'amount': _totalSum,
        'inFlow': _inFlow,
        'outFlow': _outFlow,
        'transactions': _transByMonth
      };
    },
  ).toList();
}

String getMonthsName(DateTime month) {
  if (month.year != DateTime.now().year) {
    return DateFormat('MM/yyyy').format(month);
  } else if (DateTime.now().month == month.month) {
    return 'THIS MONTH';
  }
  return DateFormat.MMMM().format(month);
}
