import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/data/model/sdui_page_items.dart';
import 'package:majadigi_mobile/http.dart';

// * Fetch List of All Available Server-Driven UI Available in CDN
/* The JSON Format is as below:
 * [
 *    {
 *      "title": "<service>",
 *      "pageLayout": "<page_url.json>"
 *      "description": "<desc>"
 *    },
 *    {
 *      "title": "<service>",
 *      "pageLayout": "<page_url.json>"
 *      "description": "<desc>"
 *    },
 *    ...
 * ]
 */
// final pageListFutureProvider = FutureProvider<List<PageItem>>((ref) async {
//   try {
//     final Response response = await dio.get('${docsURL}file_list.json');
//
//     dynamic rawData = response.data;
//     if (rawData is String) {
//       rawData = jsonDecode(rawData);
//     }
//
//     final List<dynamic> jsonList = rawData as List<dynamic>;
//     return jsonList.map((item) => PageItem.fromJson(item)).toList();
//   } on DioException catch (e) {
//     throw Exception('Dio Error [${e.response?.statusCode}]: ${e.message} \n URL: ${e.requestOptions.uri}');
//   } catch (e) {
//     throw Exception('Parsing Error: $e');
//   }
// });
final pageListFutureProvider = FutureProvider<List<PageItem>>((ref) async {
  final dio = await ref.watch(dioProvider.future);

  try {
    // final response = await dio.get('${docsURL}file_list.json');
    final response = await dio.get('refs/heads/main/file_list.json');

    dynamic rawData = response.data;
    if (rawData is String) {
      rawData = jsonDecode(rawData);
    }

    final List<dynamic> jsonList = rawData as List<dynamic>;
    return jsonList.map((item) => PageItem.fromJson(item)).toList();

  } on DioException catch (e) {
    throw Exception('Network & Cache failed: ${e.message}');
  } catch (e) {
    throw Exception('Parsing Error: $e');
  }
});

// * Fetch THE chosen layout page passed through argument
/* Since the JSON is made automatically by stac, it follows the object format
 * that starts with curly braces "{", so it uses Map<String, dynamic>
 * Different from the pageListFutureProvider which receive List<dynamic>
 */
// final pageLayoutFutureProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, pageLayout) async {
//   try {
//     final response = await dio.get('$docsURL$pageLayout');
//
//     dynamic rawData = response.data;
//     if (rawData is String) {
//       rawData = jsonDecode(rawData);
//     }
//
//     return rawData as Map<String, dynamic>;
//
//   } on DioException catch (e) {
//     throw Exception('Dio Error [${e.response?.statusCode}]: Failed to load $pageLayout');
//   }
// });
final pageLayoutFutureProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, pageLayout) async {
  final dio = await ref.watch(dioProvider.future);

  try {
    final response = await dio.get('$docsURL$pageLayout');

    dynamic rawData = response.data;
    if (rawData is String) {
      rawData = jsonDecode(rawData);
    }

    return rawData as Map<String, dynamic>;

  } on DioException catch (e) {
    throw Exception('Dio Error [${e.response?.statusCode}]: Failed to load $pageLayout');
  }
});
