// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransAdapter extends TypeAdapter<Trans> {
  @override
  Trans read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trans(
      id: fields[0] as String,
      amount: fields[1] as double,
      category: fields[2] as String,
      dateTime: fields[4] as DateTime,
      isDeposit: fields[5] as bool,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Trans obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.isDeposit);
  }
}

class FutureTransactionAdapter extends TypeAdapter<FutureTransaction> {
  @override
  FutureTransaction read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FutureTransaction(
      id: fields[0] as String,
      isDeposit: fields[1] as bool,
      costumeBill: fields[2] as Bill,
      isrecurring: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FutureTransaction obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isDeposit)
      ..writeByte(2)
      ..write(obj.costumeBill)
      ..writeByte(3)
      ..write(obj.isrecurring);
  }
}

class TransactionsAdapter extends TypeAdapter<Transactions> {
  @override
  Transactions read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transactions()
      ..total = fields[0] as double
      ..transList = (fields[2] as List)?.cast<Trans>()
      ..futureTransList = (fields[3] as List)?.cast<FutureTransaction>()
      ..recurringTransList = (fields[1] as List)?.cast<FutureTransaction>();
  }

  @override
  void write(BinaryWriter writer, Transactions obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.total)
      ..writeByte(2)
      ..write(obj.transList)
      ..writeByte(3)
      ..write(obj.futureTransList)
      ..writeByte(1)
      ..write(obj.recurringTransList);
  }
}
