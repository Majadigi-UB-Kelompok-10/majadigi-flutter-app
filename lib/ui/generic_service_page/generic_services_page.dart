import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:majadigi_mobile/ui/generic_service_page/widgets/carousel_hero_image.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/choice_chip_notifier_widget.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/expandable_text_box.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/tabbed_content_view.dart';
import 'package:majadigi_mobile/domain/generic_service_domain/generic_service_page_data_middleware.dart';

import 'package:majadigi_mobile/domain/sealed_type/tab_payload.dart';

class GenericServicesPage extends ConsumerWidget {
  final String id;
  final String title;
  final String description;

  const GenericServicesPage({super.key, required this.id, required this.title, required this.description});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(genericServicePageDataMiddlewareProvider(id));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          title,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel of Images
            CarouselHeroImage(serviceListId: id),

            SizedBox(
              height: 16.0,
            ),

            // Title
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // Description
            ExpandableTextBox(text: description),

            Divider(),

            asyncData.when(
              error: (e, s) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: $e', textAlign: TextAlign.center),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (tabData) {
                if (tabData.isEmpty) {
                  return const Center(
                    child: Text('No Data A. Contact Administrator')
                  );
                }

                // Map<int, Map<String, TabPayload>>

                // Prepare ChoiceChips
                final choiceEntry = <int, String>{};

                for (final entry in tabData.entries) {
                  choiceEntry.putIfAbsent(entry.key, () => entry.value.keys.first);
                }

                // In case something went wrong
                if (choiceEntry.isEmpty) {
                  return const Center(
                    child: Text('No Data B. Contact Administrator')
                  );
                }

                // Prepare List of TabPayloads
                final tabPayloads = <TabPayload>[];

                for (final entry in tabData.entries) {
                  tabPayloads.add(entry.value.values.first);
                }

                // In case something went wrong AGAIN
                if (tabPayloads.isEmpty) {
                  return const Center(
                    child: Text('No Data C. Contact Administrator')
                  );
                }

                return Column(
                  children: [
                    ChoiceChipWidget(choiceEntry: choiceEntry),
                    SizedBox(height: 8.0),
                    TabbedContentView(tabPayloads: tabPayloads),
                  ],
                );
              }
            ),
          ],
        ),
      )
    );
  }


}
