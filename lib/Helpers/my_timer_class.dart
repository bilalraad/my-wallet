import 'dart:async';

import '../DB/bills.dart';
import '../DB/app_state.dart';
import 'package:hive/hive.dart';
import '../DB/transactions.dart';
import '../DB/initialize_HiveDB.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bot_toast/bot_toast.dart';

final _tx =
    Hive.box(H.transactions.box()).get(H.transactions.str()) as Transactions;
final _bills = Hive.box(H.bills.box()).get(H.bills.str()) as Bills;

// simply this func. will start a perodic timer that will run once every day
Timer delay({
  Bill bill,
  FutureTransaction futureTrans, // this can be null
}) {
  return Timer(const Duration(seconds: 1), () async {
    if (bill.excuteDate.day == DateTime.now().day) {
      for (int i = 0; i < numberOfTimesThisBillHasToDue(bill); i++) {
        await excuteBill(
          bill: bill,
          futureTrans: futureTrans,
        );
      }
    }
  });
}

// This func. will decrese the remaning days of the bill until it reaches zero
// so it will reset the remaining days(if the bill or the recurring trans is forever)
// and it adds the new transaction and notify the user
// Note: this func. will not do any thing until starting date == datetime.now()
Future<void> excuteBill({
  @required FutureTransaction futureTrans,
  @required Bill bill,
}) async {
  final bool isDeposit = checkIfIsDeposit(futureTrans);
  //These idexes below are necessary to update the remaning days of the bill
  int rTIndex;
  int bIndex;
  if (futureTrans != null) {
    if (futureTrans.isrecurring) {
      rTIndex =
          _tx.recurringTransList.indexWhere((rt) => rt.id == futureTrans.id);
      if (rTIndex < 0) rTIndex += 1;
    }
  } else {
    bIndex = _bills.bills.indexWhere((b) => b.id == bill.id);
    if (bIndex < 0) bIndex += 1;
  }
  //--------------------------------------
  if (bill.billType == BillType.FutureTrans) {
    // this is special bill type[BillType.FutureTrans] this means it is only one time bill(or one time transaction)
    // its not a recurring transaction
    addNewTrans(
      bill: bill,
      isDeposit: futureTrans.isDeposit,
      transId: futureTrans.id,
    );
    BotToast.showSimpleNotification(
      title: 'New Transaction has been added',
      subTitle: 'Because you set a Future Transaction ',
      enableSlideOff: true,
      duration: const Duration(seconds: 1),
      hideCloseButton: true,
    );

    // Here in this func. [removeFutureTrans] I mixed the removing of
    // futureTrans an recurringTrans to reduce the amount of code
    _tx.removeFutureTrans(futureTrans);
  } else {
    addNewTrans(
      bill: bill,
      isDeposit: isDeposit,
      transId: bill.id ?? futureTrans.id,
    );
    BotToast.showSimpleNotification(
      title: 'New Transaction has been added',
      subTitle: 'Because you set a Bill Or recurring Transaction ',
      enableSlideOff: true,
      duration: const Duration(seconds: 1),
      hideCloseButton: true,
    );

    if (bill.endingDate == null) {
      updateExcuteDate(
        billIndex: bIndex,
        rTIndex: rTIndex,
        nExcuteDate: DateTime.now().add(Duration(days: bill.days)),
      );
    } else {
      final int _remainigDaysBeforEndingDate =
          DateTime.now().difference(bill.endingDate).inDays;
      final int _remainigDaysBeforExcuteDate =
          _remainigDaysBeforEndingDate >= bill.days
              ? bill.days
              : _remainigDaysBeforEndingDate;

      if (_remainigDaysBeforExcuteDate != 0) {
        updateExcuteDate(
          billIndex: bIndex,
          rTIndex: rTIndex,
          nExcuteDate: DateTime.now().add(Duration(
            days: _remainigDaysBeforExcuteDate,
          )),
        );
      } else {
        futureTrans == null
            ? _bills.deleteBill(bill.id)
            : _tx.removeFutureTrans(futureTrans);
      }
    }
  }
}

Future<void> addNewTrans({
  bool isDeposit,
  Bill bill,
  String transId,
  String type,
}) async {
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
      dateTime: bill.excuteDate,
      isDeposit: isDeposit,
      description: bill.description,
    ),
  );
}

bool checkIfIsDeposit(FutureTransaction ft) {
  if (ft == null) {
    return false;
  }
  return ft.isDeposit;
}

Future<void> updateExcuteDate({
  int billIndex,
  int rTIndex,
  DateTime nExcuteDate,//n= new
}) async {
  Bill nBill;
  if (rTIndex != null) {
    nBill = _tx.recurringTransList[rTIndex].costumeBill
        .updateBill(excuteDate: nExcuteDate);

    _tx.recurringTransList[rTIndex] = _tx.recurringTransList[rTIndex].update(
      costumeBill: nBill,
    );
    Hive.box(H.transactions.box()).put(1, _tx.futureTransList);
    _tx.save();
  } else {
    _bills.bills[billIndex] =
        _bills.bills[billIndex].updateBill(excuteDate: nExcuteDate);
    Hive.box(H.bills.box()).put(0, _bills.bills);
    _bills.save();
  }
}


//if you have a daily bill and you forget to oben the app
//for like a week this ffunc. will calculate how many times
//you missed to pay which in this case is 7
int numberOfTimesThisBillHasToDue(Bill b) {
  final dateTime = DateTime.now();
  int numberOfExcutions = 1;

  if (b.excuteDate.day > dateTime.day) {
    if (b.billType == BillType.Daily) {
      numberOfExcutions = dateTime.day - b.excuteDate.day;
    } else if (b.billType == BillType.Weekly) {
      numberOfExcutions = b.excuteDate.day + 7 < dateTime.day
          ? (dateTime.day - b.excuteDate.day) ~/ 7
          : 1;
    } else if (b.billType == BillType.Monthly) {
      numberOfExcutions = b.excuteDate.month < dateTime.month &&
              b.excuteDate.year == dateTime.year
          ? dateTime.month - b.excuteDate.month
          : 1;

      if (b.excuteDate.day >= dateTime.day) numberOfExcutions++;
    } else if (b.billType == BillType.Yearly) {
      numberOfExcutions = b.excuteDate.year < dateTime.year
          ? dateTime.year - b.excuteDate.year
          : 1;

      if (b.excuteDate.month >= dateTime.month &&
          b.excuteDate.day >= dateTime.day) numberOfExcutions++;
    }
  }
  return numberOfExcutions;
}
