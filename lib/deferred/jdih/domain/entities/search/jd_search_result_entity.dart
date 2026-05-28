import 'package:freezed_annotation/freezed_annotation.dart';

part 'jd_search_result_entity.freezed.dart';

/// Represents a single search result from the JDIH search endpoint.
@freezed
class JdSearchResultEntity with _$JdSearchResultEntity {
  const JdSearchResultEntity({
    required this.id,
    this.jenis,
    this.judul,
    this.ringkasan,
    this.tanggal,
    this.status,
    this.jumlahView,
  });

  @override
  final int id;

  @override
  final String? jenis;

  @override
  final String? judul;

  @override
  final String? ringkasan;

  @override
  final String? tanggal;

  @override
  final String? status;

  @override
  final int? jumlahView;
}
