import 'package:json_annotation/json_annotation.dart';

part 'alert.g.dart';

@JsonSerializable()
class Alert {
  final String message;
  final bool resubmitLink;
  const Alert(
    this.message,
    this.resubmitLink,
  );

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  Map<String, dynamic> toJson() => _$AlertToJson(this);
}
