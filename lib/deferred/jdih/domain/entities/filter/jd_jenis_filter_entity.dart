import 'package:freezed_annotation/freezed_annotation.dart';

part 'jd_jenis_filter_entity.freezed.dart';

/// Represents a jenis (document type) filter option from the JDIH API.
@freezed
class JdJenisFilterEntity with _$JdJenisFilterEntity {
  const JdJenisFilterEntity({
    required this.value,
    this.label,
  });

  @override
  final String value;

  @override
  final String? label;
}
