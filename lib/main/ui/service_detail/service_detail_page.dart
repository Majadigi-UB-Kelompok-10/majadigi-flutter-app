import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          centerTitle: true,
          backgroundColor: const Color(0xFF0047B3),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.reply, color: Colors.white),
            onPressed: () => context.pop(),
          ),
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