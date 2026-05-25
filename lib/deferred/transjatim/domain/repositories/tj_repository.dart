import '../entities/terminal/tj_terminal_entity.dart';
import '../entities/ticket/tj_ticket_entity.dart';
import '../entities/schedule/tj_schedule_entity.dart';

/// Contract for all Trans Jatim data operations.
/// Implementation lives in data/repositories/tj_repository_impl.dart
abstract class TjRepository {
  // -- Terminals (SWR cached) --
  Future<List<TjTerminalEntity>> getTerminals();
  Stream<List<TjTerminalEntity>> watchTerminals();
  Future<void> syncTerminals();

  // -- Tickets (SWR cached) --
  Future<List<TjTicketEntity>> getTickets();
  Stream<List<TjTicketEntity>> watchTickets();
  Future<void> syncTickets();

  // -- Schedule Search (remote only, parameterized) --
  Future<List<TjSearchEntity>> searchSchedules({
    required int asalId,
    required int tujuanId,
    required String tanggal,
  });

  // -- Schedule Detail (remote only) --
  Future<TjScheduleEntity?> getScheduleDetail(int id);
}
