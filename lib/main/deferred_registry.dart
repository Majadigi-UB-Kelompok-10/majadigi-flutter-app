import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/deferred/siskaperbapo/siskaperbapo_routes.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/transjatim_routes.dart';
import 'package:majadigi_mobile_rebuild/deferred/bansos/bansos_routes.dart';
import 'package:majadigi_mobile_rebuild/deferred/rssa/rssa_routes.dart';

/// List of Routes for Deferred Pages and Assets
List<RouteBase> deferredRoutes = [
  ...transjatimRoutes,
  ...bansosRoutes,
  ...siskaperbapoRoutes,
  ...rssaRoutes
];
