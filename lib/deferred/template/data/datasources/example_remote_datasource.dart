// =============================================================================
// TEMPLATE: data/datasources/{prefix}_remote_datasource.dart
// Replace {prefix}, {Prefix}, {Feature}, {module_name} with your module values.
// Abstract contract + implementation in the same file.
// =============================================================================

// TODO: Import DTO classes
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/data/models/dto/{feature}/{feature}_dto.dart';

/// Contract for this module's remote data source.
/// Uses the shared Dio instance from main (Public API Gateway).
// abstract class {Prefix}RemoteDatasource {
//   Future<List<{Feature}Dto>?> fetch{Feature}();
//   // TODO: Add more fetch/search methods per feature
// }

/// Implementation using Dio + Zstandard decompression.
// class {Prefix}RemoteDatasourceImpl implements {Prefix}RemoteDatasource {
//   final Dio dio;
//   final Zstandard? zstandard;
//   {Prefix}RemoteDatasourceImpl({required this.dio, this.zstandard});
//
//   // TODO: Set the API base prefix for this module
//   static const String _basePrefix = '/{module_name}';
//
//   @override
//   Future<List<{Feature}Dto>?> fetch{Feature}() async {
//     final response = await dio.get('$_basePrefix/{endpoint}');
//
//     if (response.statusCode != 200) return null;
//
//     // cleanupData handles Zstandard decompression if applicable
//     final data = await cleanupData(zstandard: zstandard, response: response);
//
//     // API always wraps payload in "data" key
//     return (data["data"] as List)
//         .map((json) => {Feature}Dto.fromJson(json))
//         .toList();
//   }
// }
