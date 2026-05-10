import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/widgets/carousel_hero_image.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/widgets/expandable_text_box.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/widgets/tabbed_content.dart';

class ServiceDetailPage extends StatelessWidget {
  final String serviceId;
  final String title;
  final String description;
  const ServiceDetailPage({super.key, required this.serviceId, required this.title, required this.description});

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
              CarouselHeroImage(serviceId: serviceId),

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
              TabbedContent(serviceId: serviceId),

              SizedBox(height: 24.0)
            ],
          ),
        )
    );
  }
}