import 'package:intl/intl.dart';

import '../DB/transactions.dart';

// this will put each transaction into its month
List<Map<String, Object>> getMonthlyData(List<Trans> trans) {
  
  //This will make sure to add the last 4 months of the last year
  final  currentMonth = DateTime.now().month;
  final length = currentMonth + 4;
  var countDouwn = 0;

  return List.generate(
    length,
    (index) {
      // This check means when I finish the available months 
      // in this year I can back to the last 4 months of the last year
      final _month =
          index >= currentMonth ? (12 - countDouwn++) : index + 1;
      final _currentYear = DateTime.now().year;
      final _year =
          index >= currentMonth ? _currentYear - 1 : _currentYear;

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
