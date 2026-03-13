import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:majadigi_mobile/data/model/sdui_page_items.dart';

final String baseURLs = '10.0.2.2:8080';
final String docsURL = '/api/cdn/download/docs/';

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
final pageListFutureProvider = FutureProvider<List<PageItem>>((ref) async {
  // final response = await http.get(
  //     Uri.http(baseURLs, '${docsURL}file_list.json'),
  // );

  final response = await http.get(Uri.parse('https://raw.githubusercontent.com/Majadigi-UB-Kelompok-10/majadigi-static-file/refs/heads/main/file_list.json'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body) as List<dynamic>;
    return json.map((item) => PageItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load page list: ${response.statusCode}');
  }
});

// * Fetch THE chosen layout page passed through argument
/* Since the JSON is made automatically by stac, it follows the object format
 * that starts with curly braces "{", so it uses Map<String, dynamic>
 * Different from the pageListFutureProvider which receive List<dynamic>
 */
final pageLayoutFutureProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, pageLayout) async {
  final response = await http.get(
    Uri.http(baseURLs, '$docsURL$pageLayout'),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return json;
  } else {
    throw Exception('Failed to load page layout: ${response.statusCode}');
  }
});