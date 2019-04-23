// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(json['firstName'] as String, json['lastName'] as String,
      DateTime.parse(json['date-of-birth'] as String),
      middleName: json['middleName'] as String,
      lastOrder: json['last-order'] == null
          ? null
          : DateTime.parse(json['last-order'] as String),
      orders: (json['orders'] as List)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList());
}

Map<String, dynamic> _$PersonToJson(Person instance) {
  final val = <String, dynamic>{
    'firstName': instance.firstName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('middleName', instance.middleName);
  val['lastName'] = instance.lastName;
  val['date-of-birth'] = instance.dateOfBirth.toIso8601String();
  val['last-order'] = instance.lastOrder?.toIso8601String();
  val['orders'] = instance.orders;
  return val;
}

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(json['date'] == null
      ? null
      : Order._dateTimeFromEpochUs(json['date'] as int))
    ..count = json['count'] as int
    ..itemNumber = json['itemNumber'] as int
    ..isRushed = json['isRushed'] as bool
    ..item = json['item'] == null
        ? null
        : Item.fromJson(json['item'] as Map<String, dynamic>)
    ..prepTime = json['prep-time'] == null
        ? null
        : Order._durationFromMilliseconds(json['prep-time'] as int);
}

Map<String, dynamic> _$OrderToJson(Order instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('count', instance.count);
  writeNotNull('itemNumber', instance.itemNumber);
  writeNotNull('isRushed', instance.isRushed);
  writeNotNull('item', instance.item);
  writeNotNull(
      'prep-time',
      instance.prepTime == null
          ? null
          : Order._durationToMilliseconds(instance.prepTime));
  writeNotNull('date',
      instance.date == null ? null : Order._dateTimeToEpochUs(instance.date));
  return val;
}

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item()
    ..count = json['count'] as int
    ..itemNumber = json['itemNumber'] as int
    ..isRushed = json['isRushed'] as bool;
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'count': instance.count,
      'itemNumber': instance.itemNumber,
      'isRushed': instance.isRushed
    };
