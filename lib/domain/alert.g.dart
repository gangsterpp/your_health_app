// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alert _$AlertFromJson(Map<String, dynamic> json) => Alert(
      json['message'] as String,
      json['resubmitLink'] as bool,
    );

Map<String, dynamic> _$AlertToJson(Alert instance) => <String, dynamic>{
      'message': instance.message,
      'resubmitLink': instance.resubmitLink,
    };
