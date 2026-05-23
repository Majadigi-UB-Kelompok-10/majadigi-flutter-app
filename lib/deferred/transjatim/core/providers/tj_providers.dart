import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/search/tj_search_entity.dart';
import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/core/storage.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/datasources/tj_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/datasources/tj_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/repositories/tj_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/route/tj_route_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/schedule/tj_schedule_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/terminal/tj_terminal_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/ticket/tj_ticket_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/repositories/tj_repository.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/usecase/tj_use_cases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tj_providers.g.dart';

// ---------------------------------------------------------------------------
// Datasources
// ---------------------------------------------------------------------------

/// Local Datasource for Trans Jatim (uses its own Isar instance)
/// Async because tjIsar is lazily initialized on first access.
@riverpod
Future<TjLocalDatasource> _tjLocalDatasource(Ref ref) async {
  final isar = await ref.watch(tjIsarProvider.future);
  return TjLocalDatasourceImpl(isar);
}

/// Remote Datasource for Trans Jatim (uses shared Dio & Zstandard from main)
@riverpod
TjRemoteDatasource _tjRemoteDatasource(Ref ref) {
  return TjRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
    zstandard: ref.watch(zstandardProvider),
  );
}

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

/// Repository for Trans Jatim
@riverpod
Future<TjRepository> _tjRepository(Ref ref) async {
  final localDatasource = await ref.watch(_tjLocalDatasourceProvider.future);
  final remoteDatasource = ref.watch(_tjRemoteDatasourceProvider);
  return TjRepositoryImpl(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
  );
}

// ---------------------------------------------------------------------------
// Use Cases (private)
// ---------------------------------------------------------------------------

@riverpod
Future<GetRoutesUseCase> _getRoutesUseCase(Ref ref) async {
  final repo = await ref.watch(_tjRepositoryProvider.future);
  return GetRoutesUseCase(repo);
}

@riverpod
Future<GetSchedulesUseCase> _getSchedulesUseCase(Ref ref) async {
  final repo = await ref.watch(_tjRepositoryProvider.future);
  return GetSchedulesUseCase(repo);
}

@riverpod
Future<GetTerminalsUseCase> _getTerminalsUseCase(Ref ref) async {
  final repo = await ref.watch(_tjRepositoryProvider.future);
  return GetTerminalsUseCase(repo);
}

@riverpod
Future<GetTicketsUseCase> _getTicketsUseCase(Ref ref) async {
  final repo = await ref.watch(_tjRepositoryProvider.future);
  return GetTicketsUseCase(repo);
}

@riverpod
Future<SearchSchedulesUseCase> _searchSchedulesUseCase(Ref ref) async {
  final repo = await ref.watch(_tjRepositoryProvider.future);
  return SearchSchedulesUseCase(repo);
}

@riverpod
Future<GetScheduleDetailUseCase> _getScheduleDetailUseCase(Ref ref) async {
  final repo = await ref.watch(_tjRepositoryProvider.future);
  return GetScheduleDetailUseCase(repo);
}

// Sync Use Cases
@riverpod
Future<SyncRoutesUseCase> syncRoutesUseCase(Ref ref) async {
  final repo = await ref.watch(_tjRepositoryProvider.future);
  return SyncRoutesUseCase(repo);
}

@riverpod
Future<SyncSchedulesUseCase> syncSchedulesUseCase(Ref ref) async {
  final repo = await ref.watch(_tjRepositoryProvider.future);
  return SyncSchedulesUseCase(repo);
}

@riverpod
Future<SyncTerminalsUseCase> syncTerminalsUseCase(Ref ref) async {
  final repo = await ref.watch(_tjRepositoryProvider.future);
  return SyncTerminalsUseCase(repo);
}

@riverpod
Future<SyncTicketsUseCase> syncTicketsUseCase(Ref ref) async {
  final repo = await ref.watch(_tjRepositoryProvider.future);
  return SyncTicketsUseCase(repo);
}

// ---------------------------------------------------------------------------
// Exposed Use Cases (public — consumed by UI)
// ---------------------------------------------------------------------------

/// Get all routes
@riverpod
Future<List<TjRouteEntity>> tjRoutes(Ref ref) async {
  final useCase = await ref.watch(_getRoutesUseCaseProvider.future);
  return await useCase.execute();
}

/// Get all schedules
@riverpod
Future<List<TjScheduleEntity>> tjSchedules(Ref ref) async {
  final useCase = await ref.watch(_getSchedulesUseCaseProvider.future);
  return await useCase.execute();
}

/// Get all terminals
@riverpod
Future<List<TjTerminalEntity>> tjTerminals(Ref ref) async {
  final useCase = await ref.watch(_getTerminalsUseCaseProvider.future);
  return await useCase.execute();
}

/// Get all tickets
@riverpod
Future<List<TjTicketEntity>> tjTickets(Ref ref) async {
  final useCase = await ref.watch(_getTicketsUseCaseProvider.future);
  return await useCase.execute();
}

/// Search schedules by origin, destination, and date
@riverpod
Future<List<TjSearchEntity>> tjSearchSchedules(
  Ref ref,
  String originTerminalId,
  String destinationTerminalId,
  String originTerminalName,
  String destinationTerminalName,
  String date,
) async {
  final useCase = await ref.watch(_searchSchedulesUseCaseProvider.future);
  return await useCase.execute(
    originTerminalId: originTerminalId,
    destinationTerminalId: destinationTerminalId,
    originTerminalName: originTerminalName,
    destinationTerminalName: destinationTerminalName,
    date: date,
  );
}

/// Get schedule detail by ID
@riverpod
Future<TjScheduleEntity?> tjScheduleDetail(Ref ref, int scheduleId) async {
  final useCase = await ref.watch(_getScheduleDetailUseCaseProvider.future);
  return await useCase.execute(scheduleId);
}
