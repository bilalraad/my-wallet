import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../Helpers/my_timer_class.dart';
import 'initialize_HiveDB.dart';

part 'bills.g.dart';

@HiveType()
enum BillType {
  @HiveField(0)
  Monthly,
  @HiveField(1)
  Weekly,
  @HiveField(2)
  Daily,
  @HiveField(3)
  Yearly,
  @HiveField(4)
  FutureTrans,
}

//bill model
@HiveType()
class Bill {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime startingDate;
  @HiveField(4)
  final DateTime endingDate;
  @HiveField(5)
  final String category;
  @HiveField(6)
  final BillType billType;
  @HiveField(7)
  final int days;
  @HiveField(8)
  final int remainingDays;

  Bill({
    this.description,
    @required this.days,
    @required this.remainingDays,
    @required this.billType,
    @required this.id,
    @required this.amount,
    @required this.category,
    @required this.startingDate,
    @required this.endingDate,
  });
}

final _bills = Hive.box(H.bills.box()).get(H.bills.str()) as Bills;


@HiveType()
class Bills extends HiveObject {
  @HiveField(0)
  List<Bill> bills = [];

  void addBill(Bill newBill) {
    bills = _bills.bills;

    timersList.add(
      MyTimerClass(
        id: newBill.id,
        timer: setTimer(
          bill: newBill,
          futureTrans: null,
        ),
      ),
    );

    bills.add(newBill);
    Hive.box(H.bills.box()).put(0, bills);
    _bills.save();
    print('addbill');
  }

  void deleteBill(String billid) {
    final bill = _bills.bills.firstWhere((b) => b.id == billid);
    final timerObject = timersList.firstWhere((t) => t.id == billid);

    timerObject.timer.cancel();

    bills.remove(bill);
    Hive.box(H.bills.box()).put(0, bills);
    _bills.save();
  }
}

extension billExtensions on Bill {
  Bill updateBill({
    String id,
    double amount,
    String description,
    DateTime startingDate,
    DateTime endingDate,
    String category,
    BillType billType,
    int days,
    int remainingDays,
  }) {
    Bill updatedBill = Bill(
      billType: billType == null ? this.billType : billType,
      category: category == null ? this.category : category,
      amount: amount == null ? this.amount : amount,
      id: id == null ? this.id : id,
      startingDate: startingDate == null ? this.startingDate : startingDate,
      endingDate: endingDate == null ? this.endingDate : endingDate,
      description: description == null ? this.description : description,
      days: days == null ? this.days : days,
      remainingDays: remainingDays == null ? this.remainingDays : remainingDays,
    );
    return updatedBill;
  }
}
