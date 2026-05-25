import '../entities/terminal/tj_terminal_entity.dart';
import '../entities/ticket/tj_ticket_entity.dart';
import '../entities/schedule/tj_schedule_entity.dart';
import '../repositories/tj_repository.dart';

// ---------------------------------------------------------------------------
// Terminal Use Cases
// ---------------------------------------------------------------------------

class GetTerminalsUseCase {
  final TjRepository repository;
  GetTerminalsUseCase(this.repository);

  Future<List<TjTerminalEntity>> execute() {
    return repository.getTerminals();
  }
}

class WatchTerminalsUseCase {
  final TjRepository repository;
  WatchTerminalsUseCase(this.repository);

  Stream<List<TjTerminalEntity>> execute() {
    return repository.watchTerminals();
  }
}

// ---------------------------------------------------------------------------
// Ticket Use Cases
// ---------------------------------------------------------------------------

class GetTicketsUseCase {
  final TjRepository repository;
  GetTicketsUseCase(this.repository);

  Future<List<TjTicketEntity>> execute() {
    return repository.getTickets();
  }
}

class WatchTicketsUseCase {
  final TjRepository repository;
  WatchTicketsUseCase(this.repository);

  Stream<List<TjTicketEntity>> execute() {
    return repository.watchTickets();
  }
}

// ---------------------------------------------------------------------------
// Schedule Use Cases
// ---------------------------------------------------------------------------

class SearchSchedulesUseCase {
  final TjRepository repository;
  SearchSchedulesUseCase(this.repository);

  Future<List<TjSearchEntity>> execute({
    required int asalId,
    required int tujuanId,
    required String tanggal,
  }) {
    return repository.searchSchedules(
      asalId: asalId,
      tujuanId: tujuanId,
      tanggal: tanggal,
    );
  }
}

class GetScheduleDetailUseCase {
  final TjRepository repository;
  GetScheduleDetailUseCase(this.repository);

  Future<TjScheduleEntity?> execute(int id) {
    return repository.getScheduleDetail(id);
  }
}
