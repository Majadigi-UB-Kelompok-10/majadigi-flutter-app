import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/domain/stac_parsers/stac_form_modal_builder_parser.dart';
import 'package:stac/stac.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:majadigi_mobile/ui/dynamic_page/stac_test_page.dart';
import 'package:majadigi_mobile/domain/stac_parsers/stac_cached_image_parser.dart';
import 'package:majadigi_mobile/ui/generic_service_page/generic_services_page.dart';
import 'package:majadigi_mobile/ui/homepage/home_page.dart';
import 'package:majadigi_mobile/http.dart';

Future<void> main() async {
  // Needed for Supabase, ensure Flutter Engine is bind
  // in async before run app, more info on:
  // https://supabase.com/docs/guides/getting-started/quickstarts/flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Create container to fetch dio
  final container = ProviderContainer();
  final dio = await container.read(dioProvider.future);

  // Initialize stac with custom parser & our own dio
  await Stac.initialize(
    dio: dio,
    cacheConfig: StacCacheConfig(
      strategy: StacCacheStrategy.optimistic,
      maxAge: Duration(days: 365)
    ),
    parsers: [
      const StacCachedImageParser(),
      const StacFormModalBuilderParser(),
    ],
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://nhsdrdhzkogczngslvvh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5oc2RyZGh6a29nY3puZ3NsdnZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNzQ4NjEsImV4cCI6MjA4ODg1MDg2MX0.aImo2p-pPCjyHWPRw43Hlhppc9SkkKyuG6c2Qj1j0nM'
  );

  // Main run app w/ Riverpod
  runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyStacTestPage(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majadigi Mobile App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/view') {
          final args = settings.arguments as Map<String, String>;

          if (args.isEmpty) {
            return null;
          }

          // Check first for keys
          if (!args.containsKey('id') || !args.containsKey('title') || !args.containsKey('description')) {
            return null;
          }

          return MaterialPageRoute(
            builder: (context) => GenericServicesPage(
              id: args['id'] as String,
              title: args['title'] as String,
              description: args['description'] as String
            )
          );
        }

        return null;
      },
    );
  }
}
