import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import './bills.dart';
import './initialize_HiveDB.dart';
import '../Helpers/my_timer_class.dart';

part 'transactions.g.dart';

// Transaction model
@HiveType(typeId: 7)
class Trans {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final DateTime dateTime;
  @HiveField(5)
  final bool isDeposit;

  Trans({
    @required this.id,
    @required this.amount,
    @required this.category,
    @required this.dateTime,
    @required this.isDeposit,
    this.description = '',
  });
}

// Future Transaction model
@HiveType(typeId: 8)
class FutureTransaction {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final bool isDeposit;
  @HiveField(2)
  final Bill costumeBill;
  @HiveField(3)
  final bool isrecurring;

  FutureTransaction({
    @required this.id,
    @required this.isDeposit,
    @required this.costumeBill,
    this.isrecurring = false,
  });
}

final _transactions =
    Hive.box(H.transactions.box()).get(H.transactions.str()) as Transactions;

@HiveType(typeId: 9)
class Transactions with HiveObject {
  @HiveField(0)
  double total = 0.0;

  @HiveField(2)
  List<Trans> transList = [];

//this will add oneTime Bill
  @HiveField(3)
  List<FutureTransaction> futureTransList = [];

  @HiveField(1)
  List<FutureTransaction> recurringTransList = [];

  Future<void> addTrans(Trans newTrans) async {
    if (newTrans == null) return;
    transList = _transactions.transList;
    transList.add(newTrans);
    _transactions.save();

    if (newTrans.isDeposit) {
      _transactions.total == null
          ? total = newTrans.amount
          : total = _transactions.total + newTrans.amount;
    } else {
      _transactions.total == null
          ? total = newTrans.amount
          : total = _transactions.total - newTrans.amount;
    }
    Hive.box(H.transactions.box()).put(0, total);
    Hive.box(H.transactions.box()).put(2, transList);
  }

  void addFutureTrans(FutureTransaction newFT) {
    futureTransList = _transactions.futureTransList;
    recurringTransList = _transactions.recurringTransList;

    timersList.add(
      MyTimerClass(
        id: newFT.id,
        timer: setTimer(
          bill: newFT.costumeBill,
          futureTrans: newFT,
        ),
      ),
    );

    if (newFT.isrecurring) {
      recurringTransList.add(newFT);
      Hive.box(H.transactions.box()).put(1, recurringTransList);
    } else {
      futureTransList.add(newFT);
      Hive.box(H.transactions.box()).put(3, futureTransList);
    }

    _transactions.save();
  }

  void removeFutureTrans(FutureTransaction ft) {
    recurringTransList = _transactions.recurringTransList;
    futureTransList = _transactions.futureTransList;

    timersList.firstWhere((t) => t.id == ft.id).timer.cancel();

    if (ft.isrecurring) {
      recurringTransList.remove(ft);
      Hive.box(H.transactions.box()).put(1, recurringTransList);
    } else {
      futureTransList.remove(ft);
      Hive.box(H.transactions.box()).put(3, futureTransList);
    }
    _transactions.save();
  }

  void deleteTrans(String id) {
    final _trans = _transactions.transList.firstWhere((t) => t.id == id);

    if (_trans.isDeposit) {
      _transactions.total == null
          ? total -= _trans.amount
          : total = _transactions.total - _trans.amount;
    } else {
      _transactions.total == null
          ? total += _trans.amount
          : total = _transactions.total + _trans.amount;
    }
    Hive.box(H.transactions.box()).putAt(1, total);
    transList.remove(_trans);
    Hive.box(H.transactions.box()).put(2, transList);
    _transactions.save();
  }
}

extension FutureTransExtention on FutureTransaction {
  FutureTransaction update({
    final String id,
    final bool isDeposit,
    final Bill costumeBill,
    final bool isrecurring,
  }) {
    final updatedFT = FutureTransaction(
      id: id ?? this.id,
      isDeposit: isDeposit ?? this.isDeposit,
      isrecurring: isrecurring ?? this.isrecurring,
      costumeBill: costumeBill ?? this.costumeBill,
    );
    return updatedFT;
  }
}
