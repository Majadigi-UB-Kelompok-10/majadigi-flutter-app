import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/data/parsers/stac/stac_cached_image_parser.dart';
import 'package:majadigi_mobile/ui/generic_service_page/generic_service_page.dart';
import 'package:majadigi_mobile/ui/homepage/viewmodel/home_page.dart';
import 'package:majadigi_mobile/ui/stac/screens/siskaperbapo/siskaperbapo.dart';
import 'package:stac/stac.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Needed for Supabase, ensure Flutter Engine is bind
  // in async before run app, more info on:
  // https://supabase.com/docs/guides/getting-started/quickstarts/flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize stac with custom parser
  await Stac.initialize(
    parsers: [
      const StacCachedImageParser(),
    ]
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://nhsdrdhzkogczngslvvh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5oc2RyZGh6a29nY3puZ3NsdnZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNzQ4NjEsImV4cCI6MjA4ODg1MDg2MX0.aImo2p-pPCjyHWPRw43Hlhppc9SkkKyuG6c2Qj1j0nM'
  );

  // Main run app w/ Riverpod
  runApp(
      const ProviderScope(
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/view') {
          final pageLayout = settings.arguments as List<dynamic>;

          // Get the ID of the service
          final String id = pageLayout.firstOrNull;

          if (id.isEmpty) {
            return null;
          }

          // Get title
          final String title = pageLayout.elementAtOrNull(1);

          if (title.isEmpty) {
            return null;
          }

          // Get description
          final String description = pageLayout.elementAtOrNull(2) ?? '';

          return MaterialPageRoute(
            builder: (context) => GenericServicePage(
              id: id,
              title: title,
              description: description,
            ),
          );
        } else if (settings.name == '/view/dynamic') {
          final pageArgs = settings.arguments as List<dynamic>;

          // Get the JSON Route
          final String jsonRoute = pageArgs.firstOrNull;

          if (jsonRoute.isEmpty) {
            return null;
          }

          return MaterialPageRoute(
              builder: (context) => const Siskaperbapo()
          );


          // ? Wait until converted to stac json
          // return MaterialPageRoute(
          //   builder: (context) => DynamicViewerScreen(pageLayoutName: jsonRoute)
          // );
        }

        // ! Fallback
        return null;
      },
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Siskaperbapo(),
    );
  }
}
