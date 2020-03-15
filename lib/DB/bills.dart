import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'initialize_HiveDB.dart';

part 'bills.g.dart';

@HiveType(typeId: 2)
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
@HiveType(typeId: 3)
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
  @HiveField(9)
  final DateTime excuteDate;

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
    @required this.excuteDate,
  });
}

final _bills = Hive.box(H.bills.box()).get(H.bills.str()) as Bills;

@HiveType(typeId: 4)
class Bills extends HiveObject {
  @HiveField(0)
  List<Bill> bills = [];


  void addBill(Bill newBill) {
    bills = _bills.bills;

    bills.add(newBill);
    Hive.box(H.bills.box()).put(0, bills);
    _bills.save();
  }

  void deleteBill(String billid) {
    final bill = _bills.bills.firstWhere((b) => b.id == billid);


    bills.remove(bill);
    Hive.box(H.bills.box()).put(0, bills);
    _bills.save();
  }
}

extension BillExtensions on Bill {
  Bill updateBill({
    String id,
    double amount,
    String description,
    DateTime startingDate,
    DateTime endingDate,
    DateTime excuteDate,
    String category,
    BillType billType,
    int days,
    int remainingDays,
  }) {
    final Bill updatedBill = Bill(
        billType: billType ?? this.billType,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        id: id ?? this.id,
        startingDate: startingDate ?? this.startingDate,
        endingDate: endingDate ?? this.endingDate,
        description: description ?? this.description,
        days: days ?? this.days,
        remainingDays: remainingDays ?? this.remainingDays,
        excuteDate: excuteDate ?? this.excuteDate);
    return updatedBill;
  }
}
