import 'dart:async';
import 'dart:math';

import 'package:hive/hive.dart';

import './notificationsPlugin.dart';
import '../DB/bills.dart';
import '../DB/initialize_HiveDB.dart';
import '../DB/transactions.dart';
import '../DB/app_state.dart';

class MyTimerClass {
  final Timer timer;
  final String id;

  MyTimerClass({this.timer, this.id});
}

List<MyTimerClass> timersList = [];

final Transactions _tx =
    Hive.box(H.transactions.box()).get(H.transactions.str());
final _bills = Hive.box(H.bills.box()).get(H.bills.str()) as Bills;

// this is a very mind blowing function that I ever write
// simply it will start a perodic timer that will run once every day
// and it will decrese the remaning days of the bill until it reaches zero
// so it will reset the remaining days(if the bill or the recurring trans is forever)
// and it adds the new transaction and notify the user
// Note: this func. will not do any think until starting date == datetime.now()
Timer setTimer({
  Bill bill,
  FutureTransaction futureTrans, // this can be null
}) {
  bool isDeposit = true;
  int _remainingDays = bill.remainingDays;
  //These idexes below are necessary to update the remaning days of the bill
  int rTIndex;
  int bIndex;

  if (futureTrans != null) {
    if (futureTrans.isrecurring)
      rTIndex = _tx.recurringTransList
              .indexWhere((rt) => rt.id == futureTrans.id)
              .abs() -
          1;
  } else {
    bIndex = _bills.bills.indexWhere((b) => b.id == bill.id).abs() - 1;
  }
  return Timer.periodic(
    Duration(days: 1),
    (t) async {
      if (bill.startingDate.isAfter(DateTime.now())) {
        //DO Nothing
      } else if (bill.billType == BillType.FutureTrans) {
        // this is special bill type this means it is only one time bill(or one time transaction)
        // its not a recurring transaction
        addNewTransAndNotify(
          bill: bill,
          isDeposit: isDeposit,
          transId: futureTrans.id,
          type: 'Future Transaction',
        );
        // Here in this func. below I mixed the removing of
        // futureTrans an recurringTrans to reduce the amount of code
        _tx.removeFutureTrans(futureTrans);
        t.cancel();
      } else {
        if (_remainingDays != 0) {
          _remainingDays -= 1;
          isDeposit = checkIfIsDeposit(futureTrans);
        }

        await updateRmainingdaysofBill(bIndex, rTIndex, _remainingDays);

        if (_remainingDays == 0) {
          addNewTransAndNotify(
            bill: bill,
            isDeposit: isDeposit,
            transId: bill.id,
            type: 'Bill',
          );
          _remainingDays = bill.days;

          if (bill.endingDate == null) {
            isDeposit = checkIfIsDeposit(futureTrans);
          } else {
            int _remainigDaysBeforEndingDate =
                DateTime.now().difference(bill.endingDate).inDays;

            if (_remainigDaysBeforEndingDate >= bill.days) {
              isDeposit = checkIfIsDeposit(futureTrans);
            } else if (_remainigDaysBeforEndingDate < bill.days) {
              if (_remainigDaysBeforEndingDate == 0) {
                t.cancel();
              } else {
                _remainingDays = _remainigDaysBeforEndingDate; //Note

                isDeposit = checkIfIsDeposit(futureTrans);
              }
            }
          }
        }
      }
    },
  );
}

void addNewTransAndNotify({
  bool isDeposit,
  Bill bill,
  String transId,
  String type,
}) async {
  var notifId = Random();

  final _notificationPlugin = NotificationsPlugin();

  final valueOfSaving = bill.amount.getValueOfSaving();
  double _amount = bill.amount;
  if (isDeposit) {
    _amount -= valueOfSaving;
    valueOfSaving.addToSavingTotal();
  }
  valueOfSaving.addToSavingTotal();
  _tx.addTrans(
    Trans(
      amount: _amount,
      category: bill.category,
      id: transId,
      dateTime: bill.startingDate,
      isDeposit: isDeposit,
      description: bill.description,
    ),
  );
  await _notificationPlugin.showWhenTransAddedInBackrownd(
    id: notifId.nextInt(100),
    title: 'New Transaction haas been added',
    description: 'This added because you set a $type.',
  );
}

bool checkIfIsDeposit(FutureTransaction ft) {
  if (ft == null || !ft.isrecurring) {
    return false;
  }
  return ft.isDeposit;
}

Future<void> updateRmainingdaysofBill(
  int billIndex,
  int fTIndex,
  int rDays,
) async {
  Bill nBill;
  if (fTIndex != null) {
    nBill = _tx.recurringTransList[fTIndex].costumeBill
        .updateBill(remainingDays: rDays);

    _tx.recurringTransList[fTIndex] = _tx.recurringTransList[fTIndex].update(
      costumeBill: nBill,
    );
    Hive.box(H.transactions.box()).put(1, _tx.futureTransList);
    _tx.save();
  } else {
    _bills.bills[billIndex] =
        _bills.bills[billIndex].updateBill(remainingDays: rDays);
    Hive.box(H.bills.box()).putAt(0, _bills.bills);
    _bills.save();
  }
}
