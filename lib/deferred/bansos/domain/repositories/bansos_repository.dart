import '../entities/bansos/bansos_entity.dart';

abstract class BansosRepository {
  /// Fetches bansos info by NIK. Implements Stale-While-Revalidate (SWR).
  /// Returns locally cached data immediately if available, while triggering
  /// a background fetch to update the remote data.
  Future<BansosEntity?> getBansosByNik(String nik);
  Stream<List<BansosEntity>> watchBansosByNik(String nik);

  /// Forces a background fetch to update the local cache for the given NIK.
  Future<void> syncBansosByNik(String nik);
}
