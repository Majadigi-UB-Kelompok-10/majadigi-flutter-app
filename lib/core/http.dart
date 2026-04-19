import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'http.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 3),
    )
  );

  return dio;
}

@riverpod
SupabaseClient? supabase(Ref ref) {
  if (!Supabase.instance.isInitialized) {
    return null;
  }

  return Supabase.instance.client;
}