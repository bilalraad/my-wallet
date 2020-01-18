// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PopMenuItemAdapter extends TypeAdapter<PopMenuItem> {
  @override
  PopMenuItem read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PopMenuItem.ByCat;
      case 1:
        return PopMenuItem.ByTrans;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, PopMenuItem obj) {
    switch (obj) {
      case PopMenuItem.ByCat:
        writer.writeByte(0);
        break;
      case PopMenuItem.ByTrans:
        writer.writeByte(1);
        break;
    }
  }
}

class AppStateAdapter extends TypeAdapter<AppState> {
  @override
  AppState read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppState()
      .._isDark = fields[0] as bool
      ..filter = fields[1] as PopMenuItem
      ..percentageOfSaving = fields[2] as double
      ..totalSavingAmount = fields[3] as double
      ..firstTime = fields[4] as bool
      ..myLocale = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, AppState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._isDark)
      ..writeByte(1)
      ..write(obj.filter)
      ..writeByte(2)
      ..write(obj.percentageOfSaving)
      ..writeByte(3)
      ..write(obj.totalSavingAmount)
      ..writeByte(4)
      ..write(obj.firstTime)
      ..writeByte(5)
      ..write(obj.myLocale);
  }
}
