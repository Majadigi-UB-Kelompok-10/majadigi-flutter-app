import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/route/tj_route_registry.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/schedule/tj_schedule_registry.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/terminal/tj_terminal_registry.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/ticket/tj_ticket_registry.dart';

/// Represent the Contract for Trans Jatim Local Datasource.
/// Uses Isar Database (separate instance from main).
abstract class TjLocalDatasource {
  // Route
  Future<List<IsarTjRouteRegistry>> getCachedRoutes();
  Future<void> cacheRoutes(List<IsarTjRouteRegistry> routes);

  // Schedule
  Future<List<IsarTjScheduleRegistry>> getCachedSchedules();
  Future<IsarTjScheduleRegistry?> getCachedScheduleById(int id);
  Future<List<IsarTjScheduleRegistry>> searchCachedSchedules({
    required String origin,
    required String destination,
  });
  Future<void> cacheSchedules(List<IsarTjScheduleRegistry> schedules);

  // Terminal
  Future<List<IsarTjTerminalRegistry>> getCachedTerminals();
  Future<IsarTjTerminalRegistry?> getTerminalByTerminalName({required String terminalName});
  Future<void> cacheTerminals(List<IsarTjTerminalRegistry> terminals);

  // Ticket
  Future<List<IsarTjTicketRegistry>> getCachedTickets();
  Future<IsarTjTicketRegistry?> getTicketByOriginAndDestination({
    required String originTerminalName,
    required String destinationTerminalName
  });
  Future<void> cacheTickets(List<IsarTjTicketRegistry> tickets);
}

/// Represent the Trans Jatim Local Datasource Implementation
class TjLocalDatasourceImpl implements TjLocalDatasource {
  final Isar _isar;
  TjLocalDatasourceImpl(this._isar);

  // -- Route --
  @override
  Future<List<IsarTjRouteRegistry>> getCachedRoutes() {
    return _isar.isarTjRouteRegistrys.where().findAll();
  }

  @override
  Future<void> cacheRoutes(List<IsarTjRouteRegistry> routes) async {
    await _isar.writeTxn(() async {
      await _isar.isarTjRouteRegistrys.clear();
      await _isar.isarTjRouteRegistrys.putAll(routes);
    });
  }

  // -- Schedule --
  @override
  Future<List<IsarTjScheduleRegistry>> getCachedSchedules() {
    return _isar.isarTjScheduleRegistrys.where().findAll();
  }

  @override
  Future<IsarTjScheduleRegistry?> getCachedScheduleById(int id) {
    return _isar.isarTjScheduleRegistrys
        .filter()
        .idEqualTo(id)
        .findFirst();
  }

  @override
  Future<List<IsarTjScheduleRegistry>> searchCachedSchedules({
    required String origin,
    required String destination,
  }) {
    // It's actually terminal name being passed
    return _isar.isarTjScheduleRegistrys
        .filter()
        .terminalAsalEqualTo(origin, caseSensitive: false)
        .and()
        .terminalTujuanEqualTo(destination, caseSensitive: false)
        .findAll();
  }

  @override
  Future<void> cacheSchedules(List<IsarTjScheduleRegistry> schedules) async {
    await _isar.writeTxn(() async {
      await _isar.isarTjScheduleRegistrys.clear();
      await _isar.isarTjScheduleRegistrys.putAll(schedules);
    });
  }

  // -- Terminal --
  @override
  Future<List<IsarTjTerminalRegistry>> getCachedTerminals() {
    return _isar.isarTjTerminalRegistrys.where().findAll();
  }

  @override
  Future<void> cacheTerminals(List<IsarTjTerminalRegistry> terminals) async {
    await _isar.writeTxn(() async {
      await _isar.isarTjTerminalRegistrys.clear();
      await _isar.isarTjTerminalRegistrys.putAll(terminals);
    });
  }

  // -- Ticket --
  @override
  Future<List<IsarTjTicketRegistry>> getCachedTickets() {
    return _isar.isarTjTicketRegistrys.where().findAll();
  }

  @override
  Future<void> cacheTickets(List<IsarTjTicketRegistry> tickets) async {
    await _isar.writeTxn(() async {
      await _isar.isarTjTicketRegistrys.clear();
      await _isar.isarTjTicketRegistrys.putAll(tickets);
    });
  }

  @override
  Future<IsarTjTicketRegistry?> getTicketByOriginAndDestination({required String originTerminalName, required String destinationTerminalName}) {
    return _isar.isarTjTicketRegistrys
        .filter()
        .terminalAsalEqualTo(originTerminalName, caseSensitive: false)
        .and()
        .terminalTujuanEqualTo(destinationTerminalName, caseSensitive: false)
        .findFirst();
  }

  @override
  Future<IsarTjTerminalRegistry?> getTerminalByTerminalName({required String terminalName}) {
    return _isar.isarTjTerminalRegistrys
        .filter()
        .namaEqualTo(terminalName, caseSensitive: false)
        .findFirst();
  }
}
