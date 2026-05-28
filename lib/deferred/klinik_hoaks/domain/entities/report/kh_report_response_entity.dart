import 'package:freezed_annotation/freezed_annotation.dart';

part 'kh_report_response_entity.freezed.dart';

@freezed
class KhReportResponseEntity with _$KhReportResponseEntity {
  const KhReportResponseEntity({
    this.ticketNumber,
    this.createdAt,
  });

  @override
  final String? ticketNumber;

  @override
  final String? createdAt;
}
