import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';

/// Cleanup data utility
Future<List> cleanupData({
  Zstandard? zstandard,
  required Response<dynamic> response,
}) async {
  // If it's zstd compressed, decompress it
  if (zstandard != null &&
      response.headers.value('Content-Encoding') == 'zstd') {
    return await convertZstdFromResponseToList(zstandard, response);
  }

  // Put other future compression here (Guard Clause)
  // ...

  // If it's not compressed, convert data from List<int> to Json
  final jsonData = json.decode(utf8.decode(response.data as List<int>));
  return jsonData["data"] as List;
}

/// Converts zstd compressed data to a decompressed List.
Future<List> convertZstdFromResponseToList(
  Zstandard zstandard,
  Response<dynamic> response,
) async {
  final compressedData = response.data;

  final decompressedData = await zstandard.decompress(
    Uint8List.fromList(compressedData),
  );

  return (jsonDecode(utf8.decode(decompressedData!)))["data"] as List;
}
