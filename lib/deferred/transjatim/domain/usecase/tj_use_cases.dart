import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/route/tj_route_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/schedule/tj_schedule_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/search/tj_search_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/terminal/tj_terminal_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/ticket/tj_ticket_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/repositories/tj_repository.dart';

/// Fetch all available routes
/// @return List<TjRouteEntity>
class GetRoutesUseCase {
  final TjRepository repository;

  GetRoutesUseCase(this.repository);

  Future<List<TjRouteEntity>> execute() async {
    return await repository.getRoutes();
  }
}

/// Fetch all schedules
/// @return List<TjScheduleEntity>
class GetSchedulesUseCase {
  final TjRepository repository;

  GetSchedulesUseCase(this.repository);

  Future<List<TjScheduleEntity>> execute() async {
    return await repository.getSchedules();
  }
}

/// Fetch all terminals
/// @return List<TjTerminalEntity>
class GetTerminalsUseCase {
  final TjRepository repository;

  GetTerminalsUseCase(this.repository);

  Future<List<TjTerminalEntity>> execute() async {
    return await repository.getTerminals();
  }
}

/// Fetch all ticket pricing
/// @return List<TjTicketEntity>
class GetTicketsUseCase {
  final TjRepository repository;

  GetTicketsUseCase(this.repository);

  Future<List<TjTicketEntity>> execute() async {
    return await repository.getTickets();
  }
}

/// Search schedules by origin, destination, and date
/// @return List<TjSearchEntity>
class SearchSchedulesUseCase {
  final TjRepository repository;

  SearchSchedulesUseCase(this.repository);

  Future<List<TjSearchEntity>> execute({
    required String originTerminalId,
    required String destinationTerminalId,
    required String originTerminalName,
    required String destinationTerminalName,
    required String date,
  }) async {
    return await repository.searchSchedules(
      originTerminalId: originTerminalId,
      destinationTerminalId: destinationTerminalId,
      originTerminalName: originTerminalName,
      destinationTerminalName: destinationTerminalName,
      date: date,
    );
  }
}

/// Get a single schedule detail by ID
/// @return TjScheduleEntity?
class GetScheduleDetailUseCase {
  final TjRepository repository;

  GetScheduleDetailUseCase(this.repository);

  Future<TjScheduleEntity?> execute(int scheduleId) async {
    return await repository.getScheduleDetail(scheduleId);
  }
}

/// Sync routes from remote to local cache
/// @return void
class SyncRoutesUseCase {
  final TjRepository repository;

  SyncRoutesUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncRoutes();
  }
}

/// Sync schedules from remote to local cache
/// @return void
class SyncSchedulesUseCase {
  final TjRepository repository;

  SyncSchedulesUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncSchedules();
  }
}

/// Sync terminals from remote to local cache
/// @return void
class SyncTerminalsUseCase {
  final TjRepository repository;

  SyncTerminalsUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncTerminals();
  }
}

/// Sync tickets from remote to local cache
/// @return void
class SyncTicketsUseCase {
  final TjRepository repository;

  SyncTicketsUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncTickets();
  }
}
