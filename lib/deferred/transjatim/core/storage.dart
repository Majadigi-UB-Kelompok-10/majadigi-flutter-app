import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/route/tj_route_registry.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/schedule/tj_schedule_registry.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/terminal/tj_terminal_registry.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/isar/ticket/tj_ticket_registry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage.g.dart';

/// Return the application documents directory
@riverpod
Future<Directory> tjDirectory(Ref ref) async {
  return await getApplicationDocumentsDirectory();
}

/// Trans Jatim's own Isar instance — lazily self-initializes on first access.
/// Uses keepAlive so the instance persists once opened and is never
/// garbage-collected for the lifetime of the app session.
@Riverpod(keepAlive: true)
Future<Isar> tjIsar(Ref ref) async {
  final dir = await ref.read(tjDirectoryProvider.future);

  return await Isar.open(
    [
      IsarTjRouteRegistrySchema,
      IsarTjScheduleRegistrySchema,
      IsarTjTerminalRegistrySchema,
      IsarTjTicketRegistrySchema,
    ],
    directory: dir.path,
    name: 'transjatim',
  );
}
