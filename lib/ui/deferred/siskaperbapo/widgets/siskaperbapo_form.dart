import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/http.dart';

class SiskaperbapoForm extends ConsumerStatefulWidget {
  const SiskaperbapoForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SiskaperbapoFormState();
}

class _SiskaperbapoFormState extends ConsumerState<SiskaperbapoForm> {
  final formKey = GlobalKey<FormState>;
  final Map<String, String> selectedFilters = {};

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(_asyncDataFetcher("${extBaseURL}bahan-pokok"));

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

          return Form(
            child: Padding(
              padding: EdgeInsetsGeometry.all(16.0),
              child: Column(
                spacing: 8.0,
                children: [
                  DropdownMenuFormField(
                    width: double.maxFinite,
                    dropdownMenuEntries: [
                      for (var entry in data["data"]) ...[
                        DropdownMenuEntry(
                          value: entry["komoditas"],
                          label: entry["komoditas"],
                        )
                      ]
                    ]
                  ),
                ],
              )
            )
          );
        }
    );
  }
}

final _asyncDataFetcher = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, url) async {
  final dio = await ref.watch(dioProvider.future);

  try {
    final json = await dio.get(url);

    return json.data;
  } on DioException catch (e) {
    throw Exception('Failed to fetch data: ${e.message}');
  }
});