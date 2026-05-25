import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../main/core/http.dart';
import '../storage.dart';
import '../../data/datasources/tj_local_datasource.dart';
import '../../data/datasources/tj_remote_datasource.dart';
import '../../data/repositories/tj_repository_impl.dart';
import '../../domain/repositories/tj_repository.dart';
import '../../domain/usecase/tj_use_cases.dart';
import '../../domain/entities/terminal/tj_terminal_entity.dart';
import '../../domain/entities/ticket/tj_ticket_entity.dart';
import '../../domain/entities/schedule/tj_schedule_entity.dart';

part 'tj_providers.g.dart';

// ---------------------------------------------------------------------------
// Datasources (private)
// ---------------------------------------------------------------------------

@riverpod
TjLocalDatasource _tjLocalDatasource(Ref ref) {
  final isar = ref.watch(tjIsarProvider).requireValue;
  return TjLocalDatasourceImpl(isar);
}

@riverpod
TjRemoteDatasource _tjRemoteDatasource(Ref ref) {
  final dio = ref.watch(dioProvider);
  final zstandard = ref.watch(zstandardProvider);
  return TjRemoteDatasourceImpl(dio: dio, zstandard: zstandard);
}

// ---------------------------------------------------------------------------
// Repository (private)
// ---------------------------------------------------------------------------

@riverpod
TjRepository _tjRepository(Ref ref) {
  return TjRepositoryImpl(
    localDatasource: ref.watch(_tjLocalDatasourceProvider),
    remoteDatasource: ref.watch(_tjRemoteDatasourceProvider),
  );
}

// ---------------------------------------------------------------------------
// Use Cases (private)
// ---------------------------------------------------------------------------

@riverpod
GetTerminalsUseCase _getTerminalsUseCase(Ref ref) {
  return GetTerminalsUseCase(ref.watch(_tjRepositoryProvider));
}

@riverpod
WatchTerminalsUseCase _watchTerminalsUseCase(Ref ref) {
  return WatchTerminalsUseCase(ref.watch(_tjRepositoryProvider));
}

@riverpod
GetTicketsUseCase _getTicketsUseCase(Ref ref) {
  return GetTicketsUseCase(ref.watch(_tjRepositoryProvider));
}

@riverpod
WatchTicketsUseCase _watchTicketsUseCase(Ref ref) {
  return WatchTicketsUseCase(ref.watch(_tjRepositoryProvider));
}

@riverpod
SearchSchedulesUseCase _searchSchedulesUseCase(Ref ref) {
  return SearchSchedulesUseCase(ref.watch(_tjRepositoryProvider));
}

@riverpod
GetScheduleDetailUseCase _getScheduleDetailUseCase(Ref ref) {
  return GetScheduleDetailUseCase(ref.watch(_tjRepositoryProvider));
}

// ---------------------------------------------------------------------------
// Exposed Data Providers (public — consumed by presentation layer)
// ---------------------------------------------------------------------------

/// Get all terminals
@riverpod
Future<List<TjTerminalEntity>> tjTerminals(Ref ref) {
  final useCase = ref.watch(_getTerminalsUseCaseProvider);
  return useCase.execute();
}

/// Get all tickets (reguler + luxury unified)
@riverpod
Future<List<TjTicketEntity>> tjTickets(Ref ref) {
  final useCase = ref.watch(_getTicketsUseCaseProvider);
  return useCase.execute();
}

/// Search schedules by origin terminal, destination terminal, and date.
/// Accepts string IDs and date for convenience from the presentation layer.
@riverpod
Future<List<TjSearchEntity>> tjSearchSchedules(
  Ref ref,
  String fromTerminalId,
  String toTerminalId,
  String fromTerminal,
  String toTerminal,
  String date,
) {
  final useCase = ref.watch(_searchSchedulesUseCaseProvider);
  return useCase.execute(
    asalId: int.tryParse(fromTerminalId) ?? 0,
    tujuanId: int.tryParse(toTerminalId) ?? 0,
    tanggal: date,
  );
}

/// Get schedule detail by ID
@riverpod
Future<TjScheduleEntity?> tjScheduleDetail(Ref ref, int id) {
  final useCase = ref.watch(_getScheduleDetailUseCaseProvider);
  return useCase.execute(id);
}
