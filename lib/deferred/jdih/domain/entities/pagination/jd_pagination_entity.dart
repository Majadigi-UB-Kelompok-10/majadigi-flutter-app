import 'package:freezed_annotation/freezed_annotation.dart';

part 'jd_pagination_entity.freezed.dart';

/// Represents pagination metadata from paginated JDIH endpoints.
@freezed
class JdPaginationEntity with _$JdPaginationEntity {
  const JdPaginationEntity({
    this.page,
    this.limit,
    this.total,
  });

  @override
  final int? page;

  @override
  final int? limit;

  @override
  final int? total;
}
