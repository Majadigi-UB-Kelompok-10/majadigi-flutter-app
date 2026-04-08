import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/http.dart';
import 'package:stac/stac.dart';

// Wrapper
class MyStacTestPage extends StatelessWidget {
  final String pageUrl;
  const MyStacTestPage({super.key, required this.pageUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majadigi Mobile App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home:
      _StacNoParse(pageUrl: pageUrl),
      // _StacLocalTestPage(
      //   pageUrl: "$baseURL${dataURL}siskaperbapo/siskaperbapo.json",
      //   dataUrl: "${extBaseURL}bahan-pokok",
      // ),
      // _StacTestPage(
      //   pageUrl: "$baseURL${dataURL}siskaperbapo/siskaperbapo.json",
      //   dataUrl: "$baseURL${dataURL}siskaperbapo/siskaperbapo.json",
      // ),
    );
  }
}

// No Data Parse
class _StacNoParse extends ConsumerWidget {
  final String pageUrl;
  const _StacNoParse({required this.pageUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return Stac.fromAssets('stac/.build/screens/siskaperbapo_offline.json');
    return Stac.fromNetwork(
      context: context,
      request: StacNetworkRequest(url: pageUrl, method: Method.get),
      loadingWidget: (context) => Center(child: CircularProgressIndicator()),
      errorWidget: (e, s) => Center(child: Text("Failed to Fetch Page")),
    );
  }
}

// Experimental
class _StacExperimentalPage extends ConsumerWidget {
  final String pageUrl;
  final Map<String, dynamic> dataUrls; // Assume JSONB from supabase
  const _StacExperimentalPage({required this.pageUrl, required this.dataUrls});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPage = ref.watch(_fetchOfflineDataProvider((url: pageUrl, asString: true)));

    return asyncPage.when(
      error: (e, s) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (pageData) {
        if (pageData.isEmpty) {
          return const Center(child: Text('No Data Found'));
        }

        // Convert based on keys and value
        var rawPage = pageData as String;
        for (final entries in dataUrls.entries) {
          if (entries.value is !String) {
            final convertedValue = jsonEncode(entries.value);
            rawPage = rawPage.replaceAll('"${entries.key}"', convertedValue);
            break;
          }

          rawPage = rawPage.replaceAll(entries.key, entries.value);
        }

        final convertedPage = jsonDecode(rawPage);

        // Render Stac
        return Stac.fromJson(convertedPage, context) ?? const Center(child: Text('Error: Failed to render Stac'));
      }
    );
  }
}

// Local Testing
class _StacLocalTestPage extends ConsumerWidget {
  final String pageUrl;
  final String dataUrl;
  const _StacLocalTestPage({required this.pageUrl, required this.dataUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOfflinePage = ref.watch(_fetchOfflineDataProvider((url: pageUrl, asString: true)));
    final asyncApiData = ref.watch(_asyncApiDataFetcher(dataUrl));

    return asyncOfflinePage.when(
        error: (e, s) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (pageData) {
          if (pageData.isEmpty) {
            return const Center(child: Text('No Data Found'));
          }

          // Convert
          // final convertedPage = jsonDecode((pageData as String).replaceAll(r'$dataUrl', dataUrl));
          final convertedPage = (pageData as String).replaceAll(r'$dataUrl', dataUrl);

          List<String> komoditasList = [];
          for (var entry in asyncApiData.requireValue["data"]) {
            komoditasList.add(entry["komoditas"].toString());
          }

          String replacementItems = komoditasList.map((item) => '"$item"').join(', ');

          final jsonString = convertedPage.replaceAll('"\$ListBapok"', replacementItems);

          final mostConvertedPage = jsonDecode(jsonString);

          // Render Stac
          return Stac.fromJson(mostConvertedPage, context) ?? const Center(child: Text('Error: Failed to render Stac'));
        }
    );
  }
}

// Page
class _StacTestPage extends ConsumerWidget {
  final String pageUrl;
  final String dataUrl;
  const _StacTestPage({required this.pageUrl, required this.dataUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPage = ref.watch(_fetchDataProvider((url: pageUrl, asString: true)));
    
    return asyncPage.when(
        error: (e, s) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (pageData) {
          if (pageData.isEmpty) {
            return const Center(child: Text('No Data Found'));
          }

          // Convert
          final convertedPage = jsonDecode((pageData as String).replaceAll(r'$dataUrl', dataUrl));

          // Render Stac
          return Stac.fromJson(convertedPage, context) ?? const Center(child: Text('Error: Failed to render Stac'));
        }
    );
  }
}

// Data Fetcher
typedef FetchParams = ({String url, bool asString});

final _fetchDataProvider = FutureProvider.family<dynamic, FetchParams>((ref, params) async {
  final dio = await ref.watch(dioProvider.future);

  final url = params.url;
  final asString = params.asString;

  if (url.isEmpty) {
    throw Exception('URL is Empty');
  }

  try {
    final response = await dio.get(
      url,
      options: asString ? Options(responseType: ResponseType.plain) : null,
    );

    return response.data;
  } on DioException catch (e) {
    throw Exception('Failed to fetch data: ${e.message}');
  }
});

// Simulate Future
final _fetchOfflineDataProvider = FutureProvider.family<dynamic, FetchParams>((ref, params) async {
  final url = params.url;
  final asString = params.asString;

  if (url.isEmpty) {
    throw Exception('URL is Empty');
  }

  try {
    final response = await rootBundle.loadString('stac/.build/screens/siskaperbapo_offline.json');

    return asString ? response : jsonDecode(response);
  } on DioException catch (e) {
    throw Exception('Failed to fetch data: ${e.message}');
  }
});

final _asyncApiDataFetcher = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, url) async {
  final dio = await ref.watch(dioProvider.future);

  try {
    final json = await dio.get(url);

    return json.data;
  } on DioException catch (e) {
    throw Exception('Failed to fetch data: ${e.message}');
  }
});