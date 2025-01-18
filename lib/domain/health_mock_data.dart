import 'package:json_annotation/json_annotation.dart';
import 'package:your_health_app/domain/alert.dart';
import 'package:your_health_app/domain/value.dart';

part 'health_mock_data.g.dart';

@JsonSerializable()
class HealthMockData {
  @JsonKey(defaultValue: <Value>[], name: 'dynamics')
  final List<Value> values;
  @JsonKey(defaultValue: <Alert>[])
  final List<Alert> alerts;
  const HealthMockData(
    this.values,
    this.alerts,
  );

  factory HealthMockData.fromJson(Map<String, dynamic> json) => _$HealthMockDataFromJson(json);

  Map<String, dynamic> toJson() => _$HealthMockDataToJson(this);
}
