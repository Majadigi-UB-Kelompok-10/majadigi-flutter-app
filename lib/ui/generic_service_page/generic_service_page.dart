import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/http.dart';
import 'package:majadigi_mobile/data/services/server_driven_ui_service.dart';
import 'package:majadigi_mobile/ui/dynamic_page/dynamic_widget.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

// States
class SelectedTabNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setTab(int choice) {
    state = choice;
  }

  void reset() {
    state = 0;
  }
}

final selectedTabProvider = NotifierProvider<SelectedTabNotifier, int>(() {
  return SelectedTabNotifier();
});

class GenericServicePage extends ConsumerStatefulWidget {
  final String id;
  final String title;
  final String description;
  const GenericServicePage({super.key, required this.id, required this.title, required this.description});

  @override
  ConsumerState<GenericServicePage> createState() => _GenericServicePageState();
}

class _GenericServicePageState extends ConsumerState<GenericServicePage> {
  final Map<int, String> RadioButtonChoice = {
    0: 'Layanan',
    1: 'Operasional',
    2: 'Ketentuan Umum'
  };

  @override
  Widget build(BuildContext context) {
    final activeTab = ref.watch(selectedTabProvider);
    final asyncPageData = ref.watch(jsonbFutureProvider(widget.id));

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
        child: asyncPageData.when(
          error: (e, s) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error: $e', textAlign: TextAlign.center),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image Area
                data.images.isNotEmpty ? Padding(
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
                        children: data.images.map((dynamic item) {
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
                ) : SizedBox(
                 height: 200,
                 child: CachedNetworkImage(
                   imageUrl: '$baseURL${imageURL}shared/skull.webp',
                   fit: BoxFit.contain,
                   useOldImageOnUrlChange: true,
                   placeholder: (context, url) => LinearProgressIndicator(),
                   errorWidget: (context, url, error) => Icon(Icons.error),
                 ),
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
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 24),

                      // Radio Menu Buttons (Stateful)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: RadioButtonChoice.entries.map((entry) {
                          return ChoiceChip(
                            label: Text(entry.value),
                            selected: activeTab == entry.key,
                            showCheckmark: false,
                            selectedColor: Colors.deepPurple.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            side: activeTab == entry.key ? BorderSide(
                              color: Colors.deepPurple,
                              width: 2.0,
                            ) : BorderSide.none,
                            labelStyle: TextStyle(
                              color: activeTab == entry.key ? Colors.deepPurple : Colors.black87,
                              fontWeight: activeTab == entry.key ? FontWeight.w900 : FontWeight.w400,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                ref.read(selectedTabProvider.notifier).setTab(entry.key);
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 12),

                      // Tabs
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: switch (activeTab) {
                          // ? Layanan
                          0 => ListView(
                            key: ValueKey(0),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              for (final entry in data.services.entries) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    title: Text(entry.key),
                                    tileColor: Colors.grey.shade200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(color: Colors.grey.shade500, width: 1),
                                    ),
                                    onTap: () => Navigator.pushNamed(
                                        context,
                                        '/view/dynamic',
                                        arguments: [
                                          entry.value,
                                        ]
                                    ),
                                  ),
                                )
                              ]
                            ]
                          ),

                          // ? Operasional
                          1 => ListView(
                            key: ValueKey(1),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              for (final entry in data.operationals.entries) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    title: Text(
                                      entry.key,
                                      style: const TextStyle(fontWeight: FontWeight.bold)
                                    ),
                                    tileColor: Colors.grey.shade200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(color: Colors.grey.shade500, width: 1),
                                    ),
                                    subtitle: DynamicJsonViewer(originalKey: entry.key, data: entry.value)
                                  ),
                                )
                              ]
                            ]
                          ),

                          // ? Ketentuan Umum
                          2 => ListView(
                              key: ValueKey(2),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                for (final entry in data.policies.entries) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: ExpansionTile(
                                      title: Text(
                                          entry.key,
                                          style: const TextStyle(fontWeight: FontWeight.bold)
                                      ),
                                      backgroundColor: Colors.grey.shade200,
                                      collapsedBackgroundColor: Colors.grey.shade200,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(color: Colors.grey.shade500, width: 1),
                                      ),
                                      collapsedShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(color: Colors.grey.shade500, width: 1),
                                      ),
                                      childrenPadding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                      children: [
                                        entry.value is String ? Text(entry.value) : DynamicJsonViewer(data: entry.value)
                                      ],
                                    ),
                                  )
                                ]
                              ]
                          ),
                          _ => const Center(
                            key: ValueKey(3),
                            child: Icon(Icons.error),
                          )
                        }
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}