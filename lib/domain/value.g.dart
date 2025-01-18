// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Value _$ValueFromJson(Map<String, dynamic> json) => Value(
      json['date'] as String,
      json['lab'] as String,
      (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'date': instance.date,
      'lab': instance.lab,
      'value': instance.value,
    };
