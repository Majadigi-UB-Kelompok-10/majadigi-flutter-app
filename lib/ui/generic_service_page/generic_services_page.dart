import 'package:flutter/material.dart';

import 'package:majadigi_mobile/ui/generic_service_page/widgets/carousel_hero_image.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/expandable_text_box.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/tabbed_content_view.dart';


class GenericServicesPage extends StatelessWidget {
  final String id;
  final String title;
  final String description;

  const GenericServicesPage({super.key, required this.id, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.white,
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

            // Choice Chips and Tab Content
            TabbedContentView(id: id),

            SizedBox(height: 24.0)
          ],
        ),
      )
    );
  }
}
