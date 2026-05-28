import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/deferred/bapenda/bapenda_routes.dart';
import 'package:majadigi_mobile_rebuild/deferred/jdih/jdih_routes.dart';
import 'package:majadigi_mobile_rebuild/deferred/nomor_darurat/nomor_darurat_routes.dart';
import 'package:majadigi_mobile_rebuild/deferred/siskaperbapo/siskaperbapo_routes.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/transjatim_routes.dart';
import 'package:majadigi_mobile_rebuild/deferred/bansos/bansos_routes.dart';
import 'package:majadigi_mobile_rebuild/deferred/rssa/rssa_routes.dart';
import 'package:majadigi_mobile_rebuild/deferred/klinik_hoaks/klinik_hoaks_routes.dart';

/// List of Routes for Deferred Pages and Assets
List<RouteBase> deferredRoutes = [
  ...transjatimRoutes,
  ...bansosRoutes,
  ...siskaperbapoRoutes,
  ...rssaRoutes,
  ...klinikHoaksRoutes,
  ...nomorDaruratRoutes,
  ...bapendaRoutes,
  ...jdihRoutes
];
