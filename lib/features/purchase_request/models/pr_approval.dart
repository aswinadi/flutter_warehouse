import 'package:freezed_annotation/freezed_annotation.dart';

part 'pr_approval.freezed.dart';
part 'pr_approval.g.dart';

@freezed
class ApproveRequest with _$ApproveRequest {
  const factory ApproveRequest({
    String? notes,
    @JsonKey(name: 'selected_item_ids') List<int>? selectedItemIds,
    List<ApproveRequestDetail>? details,
  }) = _ApproveRequest;

  factory ApproveRequest.fromJson(Map<String, dynamic> json) =>
      _$ApproveRequestFromJson(json);
}

@freezed
class ApproveRequestDetail with _$ApproveRequestDetail {
  const factory ApproveRequestDetail({
    required int id,
    @JsonKey(name: 'approved_qty') required double approvedQty,
    @JsonKey(name: 'approval_notes') String? approvalNotes,
  }) = _ApproveRequestDetail;

  factory ApproveRequestDetail.fromJson(Map<String, dynamic> json) =>
      _$ApproveRequestDetailFromJson(json);
}
