import 'package:isar_community/isar.dart';
import '../models/isar/terminal/tj_terminal_registry.dart';
import '../models/isar/ticket/tj_ticket_registry.dart';

/// Contract for Trans Jatim's local data source.
abstract class TjLocalDatasource {
  // -- Terminals --
  Future<List<IsarTjTerminalRegistry>> getCachedTerminals();
  Stream<List<IsarTjTerminalRegistry>> watchCachedTerminals();
  Future<void> cacheTerminals(List<IsarTjTerminalRegistry> items);

  // -- Tickets --
  Future<List<IsarTjTicketRegistry>> getCachedTickets();
  Stream<List<IsarTjTicketRegistry>> watchCachedTickets();
  Future<void> cacheTickets(List<IsarTjTicketRegistry> items);
}

/// Implementation using Isar database.
class TjLocalDatasourceImpl implements TjLocalDatasource {
  final Isar _isar;
  TjLocalDatasourceImpl(this._isar);

  // -- Terminals --

  @override
  Future<List<IsarTjTerminalRegistry>> getCachedTerminals() {
    return _isar.isarTjTerminalRegistrys.where().findAll();
  }

  @override
  Stream<List<IsarTjTerminalRegistry>> watchCachedTerminals() {
    return _isar.isarTjTerminalRegistrys
        .where()
        .watch(fireImmediately: true);
  }

  @override
  Future<void> cacheTerminals(List<IsarTjTerminalRegistry> items) async {
    await _isar.writeTxn(() async {
      await _isar.isarTjTerminalRegistrys.clear();
      await _isar.isarTjTerminalRegistrys.putAll(items);
    });
  }

  // -- Tickets --

  @override
  Future<List<IsarTjTicketRegistry>> getCachedTickets() {
    return _isar.isarTjTicketRegistrys.where().findAll();
  }

  @override
  Stream<List<IsarTjTicketRegistry>> watchCachedTickets() {
    return _isar.isarTjTicketRegistrys
        .where()
        .watch(fireImmediately: true);
  }

  @override
  Future<void> cacheTickets(List<IsarTjTicketRegistry> items) async {
    await _isar.writeTxn(() async {
      await _isar.isarTjTicketRegistrys.clear();
      await _isar.isarTjTicketRegistrys.putAll(items);
    });
  }
}
