import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/data/parsers/stac/stac_cached_image_parser.dart';
import 'package:majadigi_mobile/ui/generic_service_page/generic_service_page.dart';
import 'package:majadigi_mobile/ui/homepage/viewmodel/home_page.dart';
import 'package:majadigi_mobile/ui/stac/screens/siskaperbapo/siskaperbapo.dart';
import 'package:stac/stac.dart';

void main() async {
  await Stac.initialize(
    parsers: [
      const StacCachedImageParser(),
    ]
  );

  runApp(
      const ProviderScope(
          child: const MyApp()
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

          // EXTRACT AND CAST
          final String title = pageLayout.elementAt(0);
          final Map<String, dynamic> pageLayouts = pageLayout.elementAt(1);
          final String description = pageLayout.elementAt(2);
          final List<dynamic> images = pageLayout.elementAt(3);

          return MaterialPageRoute(
            builder: (context) => GenericServicePage(
                title: title,
                pageLayouts: pageLayouts,
                description: description,
                images: images,
            ),
          );
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
