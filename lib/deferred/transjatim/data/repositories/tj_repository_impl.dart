import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/datasources/tj_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/datasources/tj_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/route/tj_route_registry.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/schedule/tj_schedule_registry.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/terminal/tj_terminal_registry.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/ticket/tj_ticket_registry.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/dto/route/route_dto.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/dto/schedule/schedule_dto.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/dto/terminal/terminal_dto.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/dto/ticket/ticket_dto.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/route/tj_route_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/schedule/tj_schedule_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/search/tj_search_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/terminal/tj_terminal_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/ticket/tj_ticket_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/repositories/tj_repository.dart';

// ---------------------------------------------------------------------------
// DTO → Isar Registry Mapping Extensions
// These keep DTOs untouched per project rules while providing clean conversion.
// ---------------------------------------------------------------------------

extension RouteDtoToIsar on RouteDto {
  IsarTjRouteRegistry toIsar() {
    return IsarTjRouteRegistry()
      ..id = id
      ..slug = slug
      ..terminalAsal = terminalAsal
      ..terminalTujuan = terminalTujuan
      ..kotaAsal = kotaAsal
      ..kotaTujuan = kotaTujuan
      ..durasiMenit = durasiMenit
      ..aktif = aktif;
  }
}

extension ScheduleDtoToIsar on ScheduleDto {
  IsarTjScheduleRegistry toIsar() {
    return IsarTjScheduleRegistry()
      ..id = id
      ..busKode = busKode
      ..busLayanan = busLayanan
      ..terminalAsal = terminalAsal
      ..terminalTujuan = terminalTujuan
      ..ruteSlug = ruteSlug
      ..jamBerangkat = jamBerangkat
      ..jamTiba = jamTiba
      ..hariOperasi = hariOperasi
      ..aktif = aktif;
  }
}

extension TerminalDtoToIsar on TerminalDto {
  IsarTjTerminalRegistry toIsar() {
    return IsarTjTerminalRegistry()
      ..id = id
      ..nama = nama
      ..kota = kota
      ..slug = slug
      ..lat = lat
      ..lng = lng
      ..aktif = aktif;
  }
}

extension TicketDtoToIsar on TicketDto {
  IsarTjTicketRegistry toIsar() {
    return IsarTjTicketRegistry()
      ..id = id
      ..ruteId = ruteId
      ..terminalAsal = terminalAsal
      ..terminalTujuan = terminalTujuan
      ..layanan = layanan
      ..tipePenumpang = tipePenumpang
      ..harga = harga;
  }
}

// ---------------------------------------------------------------------------
// Repository Implementation
// ---------------------------------------------------------------------------

class TjRepositoryImpl implements TjRepository {
  final TjLocalDatasource localDatasource;
  final TjRemoteDatasource remoteDatasource;

  TjRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  // -- Routes --
  @override
  Future<List<TjRouteEntity>> getRoutes() async {
    // Fire and forget
    syncRoutes();

    final cached = await localDatasource.getCachedRoutes();
    return cached.map((r) => r.toEntity()).toList();
  }

  @override
  Future<void> syncRoutes() async {
    try {
      final dtos = await remoteDatasource.fetchRoutes();
      if (dtos == null) return;

      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cacheRoutes(registries);
    } catch (e) { /* None */ }
  }

  // -- Schedules --
  @override
  Future<List<TjScheduleEntity>> getSchedules() async {
    // Fire and forget
    syncSchedules();

    final cached = await localDatasource.getCachedSchedules();
    return cached.map((s) => s.toEntity()).toList();
  }

  @override
  Future<List<TjSearchEntity>> searchSchedules({
    required String originTerminalId,
    required String destinationTerminalId,
    required String originTerminalName,
    required String destinationTerminalName,
    required String date,
  }) async {
    // Fire and forget
    await syncSchedules();

    // Try remote first
    // try {
    //   final dtos = await remoteDatasource.searchSchedules(
    //     origin: originTerminalId,
    //     destination: destinationTerminalId,
    //     date: date,
    //   );
    //
    //   if (dtos != null) {
    //     return dtos.map((d) => TjScheduleEntity(
    //       id: d.id,
    //       busKode: d.busKode,
    //       busLayanan: d.busLayanan,
    //       terminalAsal: d.terminalAsal,
    //       terminalTujuan: d.terminalTujuan,
    //       ruteSlug: d.ruteSlug,
    //       jamBerangkat: d.jamBerangkat,
    //       jamTiba: d.jamTiba,
    //       hariOperasi: d.hariOperasi,
    //       aktif: d.aktif,
    //     )).toList();
    //   }
    // } catch (e) { /* Fallback to local */ }

    // Fallback: search local cache
    final cached = await localDatasource.searchCachedSchedules(
      origin: originTerminalName,
      destination: destinationTerminalName,
    );

    final scheduleEntities = cached.map((s) => s.toEntity()).toList();

    // Get the price from TjTicketEntity and city from TjTerminalEntity
    // Acquire price
    final ticket = await localDatasource.getTicketByOriginAndDestination(originTerminalName: originTerminalName, destinationTerminalName: destinationTerminalName);

    if (ticket == null) {
      return <TjSearchEntity>[];
    }

    final price = ticket.harga ?? 0.0;

    // Acquire city
    final originTerminal = await localDatasource.getTerminalByTerminalName(terminalName: originTerminalName);
    final destinationTerminal = await localDatasource.getTerminalByTerminalName(terminalName: destinationTerminalName);

    if (originTerminal == null || destinationTerminal == null) {
      return <TjSearchEntity>[];
    }

    final originCity = originTerminal.kota ?? 'Unidentified City';
    final destinationCity = destinationTerminal.kota ?? 'Unidentified City';

    List<TjSearchEntity> searchData = <TjSearchEntity>[];

    for (final schedule in scheduleEntities) {
      searchData.add(TjSearchEntity(
        id: schedule.id,
        price: price,
        originCity: originCity,
        destinationCity: destinationCity,
        arrivalTime: schedule.jamTiba,
        departureTime: schedule.jamBerangkat,
        busKode: schedule.busKode,
        destinationTerminal: destinationTerminalName,
        originTerminal: originTerminalName
      ));
    }

    return searchData;
  }

  @override
  Future<TjScheduleEntity?> getScheduleDetail(int scheduleId) async {
    // Try remote first
    try {
      final dto = await remoteDatasource.fetchScheduleDetail(scheduleId);
      if (dto != null) {
        return TjScheduleEntity(
          id: dto.id,
          busKode: dto.busKode,
          busLayanan: dto.busLayanan,
          terminalAsal: dto.terminalAsal,
          terminalTujuan: dto.terminalTujuan,
          ruteSlug: dto.ruteSlug,
          jamBerangkat: dto.jamBerangkat,
          jamTiba: dto.jamTiba,
          hariOperasi: dto.hariOperasi,
          aktif: dto.aktif,
        );
      }
    } catch (e) { /* Fallback to local */ }

    // Fallback: check local cache
    final cached = await localDatasource.getCachedScheduleById(scheduleId);
    return cached?.toEntity();
  }

  @override
  Future<void> syncSchedules() async {
    try {
      final dtos = await remoteDatasource.fetchSchedules();
      if (dtos == null) return;

      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cacheSchedules(registries);
    } catch (e) { /* None */ }
  }

  // -- Terminals --
  @override
  Future<List<TjTerminalEntity>> getTerminals() async {
    // Fire and forget
    await syncTerminals();

    final cached = await localDatasource.getCachedTerminals();
    return cached.map((t) => t.toEntity()).toList();
  }

  @override
  Future<void> syncTerminals() async {
    try {
      final dtos = await remoteDatasource.fetchTerminals();
      if (dtos == null) return;

      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cacheTerminals(registries);
    } catch (e) { /* None */ }
  }

  // -- Tickets --
  @override
  Future<List<TjTicketEntity>> getTickets() async {
    // Fire and forget
    await syncTickets();

    final cached = await localDatasource.getCachedTickets();
    return cached.map((t) => t.toEntity()).toList();
  }

  @override
  Future<void> syncTickets() async {
    try {
      final dtos = await remoteDatasource.fetchTickets();
      if (dtos == null) return;

      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cacheTickets(registries);
    } catch (e) { /* None */ }
  }
}
