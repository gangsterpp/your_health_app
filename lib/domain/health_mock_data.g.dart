// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_mock_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthMockData _$HealthMockDataFromJson(Map<String, dynamic> json) =>
    HealthMockData(
      (json['dynamics'] as List<dynamic>?)
              ?.map((e) => Value.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      (json['alerts'] as List<dynamic>?)
              ?.map((e) => Alert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HealthMockDataToJson(HealthMockData instance) =>
    <String, dynamic>{
      'dynamics': instance.values,
      'alerts': instance.alerts,
    };
