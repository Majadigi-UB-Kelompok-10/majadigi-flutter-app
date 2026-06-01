import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/isar/area/sd_area_registry.dart';
import '../data/models/isar/destination/sd_destination_recommendation_registry.dart';
import '../data/models/isar/event/sd_event_recommendation_registry.dart';
import '../data/models/isar/event/sd_event_year_registry.dart';
import '../data/models/isar/hotel/sd_hotel_recommendation_registry.dart';

part 'storage.g.dart';

/// Return the application documents directory.
@riverpod
Future<Directory> sdDirectory(Ref ref) async {
  return await getApplicationDocumentsDirectory();
}

/// This module's own Isar instance — lazily self-initializes on first access.
/// Uses keepAlive so the instance persists once opened.
@Riverpod(keepAlive: true)
Future<Isar> sdIsar(Ref ref) async {
  final dir = await ref.read(sdDirectoryProvider.future);

  return await Isar.open(
    [
      IsarSdAreaRegistrySchema,
      IsarSdDestinationRecommendationRegistrySchema,
      IsarSdHotelRecommendationRegistrySchema,
      IsarSdEventRecommendationRegistrySchema,
      IsarSdEventYearRegistrySchema,
    ],
    directory: dir.path,
    name: 'sidita',
  );
}
