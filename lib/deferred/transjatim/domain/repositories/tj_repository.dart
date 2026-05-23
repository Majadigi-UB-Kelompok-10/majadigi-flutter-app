import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/route/tj_route_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/schedule/tj_schedule_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/search/tj_search_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/terminal/tj_terminal_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/ticket/tj_ticket_entity.dart';

/// Represent contracts for Trans Jatim data
abstract class TjRepository {
  /// Fetch all available routes
  Future<List<TjRouteEntity>> getRoutes();

  /// Fetch all schedules
  Future<List<TjScheduleEntity>> getSchedules();

  /// Fetch all terminals
  Future<List<TjTerminalEntity>> getTerminals();

  /// Fetch all ticket pricing
  Future<List<TjTicketEntity>> getTickets();

  /// Search schedules by origin, destination, and date
  Future<List<TjSearchEntity>> searchSchedules({
    required String originTerminalId,
    required String destinationTerminalId,
    required String originTerminalName,
    required String destinationTerminalName,
    required String date,
  });

  /// Get a single schedule detail by ID
  Future<TjScheduleEntity?> getScheduleDetail(int scheduleId);

  // SWR-like: sync remote data to local cache
  Future<void> syncRoutes();
  Future<void> syncSchedules();
  Future<void> syncTerminals();
  Future<void> syncTickets();
}
