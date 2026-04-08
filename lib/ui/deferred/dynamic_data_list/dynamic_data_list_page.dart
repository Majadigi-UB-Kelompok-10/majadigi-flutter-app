import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/http.dart';

// Wrapper
class MyListTestPage extends StatelessWidget {
  const MyListTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '[ TEST ] [ PAGE ]',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FetchDataPage()
    );
  }
}

class FetchDataPage extends ConsumerWidget {
  const FetchDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(asyncFetchSomeData("${extBaseURL}bahan-pokok"));
    
    return asyncData.when(
      error: (e, s) => Center(
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            Text(e.toString(), style: TextStyle(color: Colors.red))
          ],
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      data: (data) {
        if (data.isEmpty) {
          return const Center(child: Text('No Data Found'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Data List'),
          ),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    for (var items in data["data"]) ...[
                      Text(items["komoditas"].toString()),

                      Text(items["slug"].toString()),

                      SizedBox(height: 10.0),
                    ]
                  ],
                ),
              ),
              for (final entry in data.entries) ...[
                ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value.toString()),
                )
              ]
            ],
          ),
        );
      }
    );
  }
}

// Async Provider
final asyncFetchSomeData = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, url) async {
  final dio = await ref.watch(dioProvider.future);

  try {
    final json = await dio.get(url);

    return json.data;
  } on DioException catch (e) {
    throw Exception('Failed to fetch data: ${e.message}');
  }
});