import 'package:json_annotation/json_annotation.dart';

part 'value.g.dart';

@JsonSerializable()
class Value {
  final String date;
  final String lab;
  final double value;
  const Value(
    this.date,
    this.lab,
    this.value,
  );

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);

  Map<String, dynamic> toJson() => _$ValueToJson(this);
}
