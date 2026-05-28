import 'package:freezed_annotation/freezed_annotation.dart';

part 'kh_track_report_entity.freezed.dart';

@freezed
class KhTrackReportEntity with _$KhTrackReportEntity {
  const KhTrackReportEntity({
    this.reportId,
    this.ticketNumber,
    this.reporterName,
    this.reportStatus,
    this.reportedAt,
  });

  @override
  final String? reportId;

  @override
  final String? ticketNumber;

  @override
  final String? reporterName;

  @override
  final String? reportStatus;

  @override
  final String? reportedAt;
}
