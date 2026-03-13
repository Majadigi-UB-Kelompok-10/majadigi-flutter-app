import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:majadigi_mobile/data/services/server_driven_ui_service.dart';
import 'package:majadigi_mobile/http.dart';

class GenericServicePage extends StatefulWidget {
  final String title;
  final Map<String, dynamic> pageLayouts;
  final String description;
  final List<dynamic> images;
  const GenericServicePage({super.key, required this.title, required this.pageLayouts, required this.description, required this.images});

  @override
  State<GenericServicePage> createState() => _GenericServicePageState();
}

class _GenericServicePageState extends State<GenericServicePage> {
  final List<String> RadioButtonChoice = [
    'Layanan',
    'Operasional',
    'Ketentuan Umum'
  ];

  String _selectedOption = 'Layanan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Image Area
            widget.images.isNotEmpty ? Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: SizedBox(
                height: 200,
                child: CarouselView.weighted(
                    flexWeights: [1,7,1],
                    consumeMaxWeight: true,
                    scrollDirection: Axis.horizontal,
                    itemSnapping: true,
                    children: widget.images.map((dynamic item) {
                      String imagePath = '$baseURL$imageURL${item as String}';

                      return CachedNetworkImage(
                        imageUrl: imagePath,
                        fit: BoxFit.contain,
                        useOldImageOnUrlChange: true,
                        placeholder: (context, url) => LinearProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    }).toList()
                ),
              ),
            ) : CachedNetworkImage(
              imageUrl: '$baseURL${imageURL}logo-provinsi-jawa-timur.webp',
              fit: BoxFit.contain,
              useOldImageOnUrlChange: true,
              placeholder: (context, url) => LinearProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),

            // 2. Main Content Area
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 24),

                  // Radio Menu Buttons (Stateful)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: RadioButtonChoice.map((options) {
                        return ChoiceChip(
                          label: Text(options),
                          selected: _selectedOption == options,
                          showCheckmark: false,
                          selectedColor: Colors.deepPurple.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          side: _selectedOption == options ? BorderSide(
                            color: Colors.deepPurple,
                            width: 2.0,
                          ) : BorderSide.none,
                          labelStyle: TextStyle(
                            color: _selectedOption == options ? Colors.deepPurple : Colors.black87,
                            fontWeight: _selectedOption == options ? FontWeight.w900 : FontWeight.w400,
                          ),
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedOption = options;
                            });
                          },
                        );
                      }
                    ).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}