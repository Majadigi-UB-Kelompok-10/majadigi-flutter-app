import '../../domain/entities/terminal/tj_terminal_entity.dart';
import '../../domain/entities/ticket/tj_ticket_entity.dart';
import '../../domain/entities/schedule/tj_schedule_entity.dart';
import '../../domain/repositories/tj_repository.dart';
import '../datasources/tj_local_datasource.dart';
import '../datasources/tj_remote_datasource.dart';
import '../models/dto/terminal/terminal_dto.dart';
import '../models/dto/ticket/ticket_dto.dart';
import '../models/dto/schedule/schedule_dto.dart';
import '../models/isar/terminal/tj_terminal_registry.dart';
import '../models/isar/ticket/tj_ticket_registry.dart';

// ---------------------------------------------------------------------------
// DTO → Isar Registry Mapping Extensions
// ---------------------------------------------------------------------------

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

extension RegulerTicketDtoToIsar on RegulerTicketDto {
  IsarTjTicketRegistry toIsar() {
    return IsarTjTicketRegistry()
      ..layanan = 'reguler'
      ..tipePenumpang = tipePenumpang
      ..harga = harga
      ..keterangan = keterangan;
  }
}

extension LuxuryTicketDtoToIsar on LuxuryTicketDto {
  IsarTjTicketRegistry toIsar() {
    return IsarTjTicketRegistry()
      ..layanan = 'luxury'
      ..ruteNama = ruteNama
      ..harga = harga
      ..fasilitas = fasilitas;
  }
}

// ---------------------------------------------------------------------------
// DTO → Entity Mapping (for non-cached schedule data)
// ---------------------------------------------------------------------------

extension SearchScheduleDtoToEntity on SearchScheduleDto {
  TjSearchEntity toEntity({
    String? originCity,
    String? destinationCity,
    double? originLat,
    double? originLng,
    double? destLat,
    double? destLng,
  }) {
    return TjSearchEntity(
      id: id,
      busKode: busKode,
      busLayanan: busLayanan,
      departureTime: jamBerangkat,
      arrivalTime: jamTiba,
      durasiMenit: durasiMenit,
      originTerminal: terminalAsal,
      destinationTerminal: terminalTujuan,
      originCity: originCity,
      destinationCity: destinationCity,
      price: harga,
      originLatitude: originLat,
      originLongitude: originLng,
      destinationLatitude: destLat,
      destinationLongitude: destLng,
    );
  }
}

extension DetailScheduleDtoToEntity on DetailScheduleDto {
  TjScheduleEntity toEntity() {
    return TjScheduleEntity(
      id: id,
      busKode: busKode,
      busLayanan: busLayanan,
      jamBerangkat: jamBerangkat,
      jamTiba: jamTiba,
      durasiMenit: durasiMenit,
      terminalAsal: terminalAsal,
      terminalTujuan: terminalTujuan,
      ruteId: ruteId,
      stops: stops,
      semuaHarga: semuaHarga
          ?.map((h) => TjHargaEntity(
                tipePenumpang: h.tipePenumpang,
                harga: h.harga,
              ))
          .toList(),
    );
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

  // -- Terminals (SWR) --

  @override
  Future<List<TjTerminalEntity>> getTerminals() async {
    await syncTerminals();
    final cached = await localDatasource.getCachedTerminals();
    return cached.map((r) => r.toEntity()).toList();
  }

  @override
  Stream<List<TjTerminalEntity>> watchTerminals() {
    syncTerminals();
    return localDatasource.watchCachedTerminals().map((terminals) {
      return terminals.map((t) => t.toEntity()).toList();
    });
  }

  @override
  Future<void> syncTerminals() async {
    try {
      final dtos = await remoteDatasource.fetchTerminals();
      if (dtos == null) return;
      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cacheTerminals(registries);
    } catch (e) { /* Silently fail — cached data still available */ }
  }

  // -- Tickets (SWR) --

  @override
  Future<List<TjTicketEntity>> getTickets() async {
    await syncTickets();
    final cached = await localDatasource.getCachedTickets();
    return cached.map((r) => r.toEntity()).toList();
  }

  @override
  Stream<List<TjTicketEntity>> watchTickets() {
    syncTickets();
    return localDatasource.watchCachedTickets().map((tickets) {
      return tickets.map((t) => t.toEntity()).toList();
    });
  }

  @override
  Future<void> syncTickets() async {
    try {
      final ticketDto = await remoteDatasource.fetchTickets();
      if (ticketDto == null) return;

      final List<IsarTjTicketRegistry> registries = [];
      if (ticketDto.regulerTicketList != null) {
        registries.addAll(ticketDto.regulerTicketList!.map((d) => d.toIsar()));
      }
      if (ticketDto.luxuryTicketList != null) {
        registries.addAll(ticketDto.luxuryTicketList!.map((d) => d.toIsar()));
      }
      await localDatasource.cacheTickets(registries);
    } catch (e) { /* Silently fail — cached data still available */ }
  }

  // -- Schedule Search (remote, cross-references terminals for geo+city) --

  @override
  Future<List<TjSearchEntity>> searchSchedules({
    required int asalId,
    required int tujuanId,
    required String tanggal,
  }) async {
    final dtos = await remoteDatasource.searchSchedules(
      asalId: asalId,
      tujuanId: tujuanId,
      tanggal: tanggal,
    );
    if (dtos == null) return [];

    // Cross-reference cached terminals for city and geo data
    final terminals = await localDatasource.getCachedTerminals();
    final terminalMap = {for (var t in terminals) t.nama: t};

    return dtos.map((dto) {
      final origin = terminalMap[dto.terminalAsal];
      final destination = terminalMap[dto.terminalTujuan];

      return dto.toEntity(
        originCity: origin?.kota,
        destinationCity: destination?.kota,
        originLat: origin?.lat,
        originLng: origin?.lng,
        destLat: destination?.lat,
        destLng: destination?.lng,
      );
    }).toList();
  }

  // -- Schedule Detail (remote) --

  @override
  Future<TjScheduleEntity?> getScheduleDetail(int id) async {
    final dto = await remoteDatasource.fetchScheduleDetail(id);
    return dto?.toEntity();
  }
}
