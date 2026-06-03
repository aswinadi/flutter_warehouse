import 'package:freezed_annotation/freezed_annotation.dart';

part 'pr_rejection.freezed.dart';
part 'pr_rejection.g.dart';

@freezed
class RejectRequest with _$RejectRequest {
  const factory RejectRequest({
    required String reason,
    String? notes,
  }) = _RejectRequest;

  factory RejectRequest.fromJson(Map<String, dynamic> json) =>
      _$RejectRequestFromJson(json);
}
