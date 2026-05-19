import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';

/// Cleanup data utility
Future<dynamic> cleanupData({
  Zstandard? zstandard,
  required Response<dynamic> response,
}) async {
  // If it's zstd compressed, decompress it
  if (zstandard != null &&
      response.headers.value('content-encoding') != null &&
      response.headers.value('content-encoding')!.isNotEmpty &&
      response.headers.value('content-encoding')!.contains('zstd')) {
    return await convertZstdFromResponseToList(zstandard, response);
  }

  // Put other future compression here (Guard Clause)
  // ...

  // If it's not compressed, convert data from Json
  final jsonData = await Isolate.run(() => json.decode(response.data));
  return jsonData;
}

/// Converts zstd compressed data to a decompressed List.
Future<dynamic> convertZstdFromResponseToList(
  Zstandard zstandard,
  Response<dynamic> response,
) async {
  final compressedData = response.data;

  final decompressedData = await Isolate.run(() => zstandard.decompress(
    Uint8List.fromList(compressedData),
  ));

  return (jsonDecode(utf8.decode(decompressedData!)));
}
