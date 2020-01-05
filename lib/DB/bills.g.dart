// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bills.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillTypeAdapter extends TypeAdapter<BillType> {
  @override
  BillType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BillType.Monthly;
      case 1:
        return BillType.Weekly;
      case 2:
        return BillType.Daily;
      case 3:
        return BillType.Yearly;
      case 4:
        return BillType.FutureTrans;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, BillType obj) {
    switch (obj) {
      case BillType.Monthly:
        writer.writeByte(0);
        break;
      case BillType.Weekly:
        writer.writeByte(1);
        break;
      case BillType.Daily:
        writer.writeByte(2);
        break;
      case BillType.Yearly:
        writer.writeByte(3);
        break;
      case BillType.FutureTrans:
        writer.writeByte(4);
        break;
    }
  }
}

class BillAdapter extends TypeAdapter<Bill> {
  @override
  Bill read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bill(
      description: fields[2] as String,
      days: fields[7] as int,
      remainingDays: fields[8] as int,
      billType: fields[6] as BillType,
      id: fields[0] as String,
      amount: fields[1] as double,
      category: fields[5] as String,
      startingDate: fields[3] as DateTime,
      endingDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Bill obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startingDate)
      ..writeByte(4)
      ..write(obj.endingDate)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.billType)
      ..writeByte(7)
      ..write(obj.days)
      ..writeByte(8)
      ..write(obj.remainingDays);
  }
}

class BillsAdapter extends TypeAdapter<Bills> {
  @override
  Bills read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bills()..bills = (fields[0] as List)?.cast<Bill>();
  }

  @override
  void write(BinaryWriter writer, Bills obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.bills);
  }
}
