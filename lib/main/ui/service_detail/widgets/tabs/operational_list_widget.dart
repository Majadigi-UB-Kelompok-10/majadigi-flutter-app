import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/operational/operational_entity.dart';
import 'package:url_launcher/link.dart';

// Only address, operational_hour, and social_media
// is optional in database. Skip null check is fine

class OperationalListWidget extends StatelessWidget {
  final List<OperationalEntity> data;
  const OperationalListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        separatorBuilder: (context, index) => const Divider(height: 12.0),
        itemBuilder: (context, index) {
          final entry = data[index];

          return Column(
            spacing: 12.0,
            children: [
              // Link Layanan
              if (entry.serviceUrl != null && entry.serviceUrl!.isNotEmpty) ...{
                _ServiceUrlListTile(serviceUrl: entry.serviceUrl!),
              },

              // Alamat
              if (entry.address != null && entry.address!.isNotEmpty) ...{
                _AddressListTile(address: entry.address!),
              },

              // Jam Operasional
              if (entry.operationalHour != null && entry.operationalHour!.isNotEmpty) ...{
                _OperationalHourListTile(operationalHour: entry.operationalHour!),
              },

              // Media Sosial
              if (entry.socialMedia != null && entry.socialMedia!.isNotEmpty) ...{
                _SocialMediaListTile(socialMedia: entry.socialMedia!),
              }
            ],
          );
        },
      ),
    );
  }
}

class _ServiceUrlListTile extends StatelessWidget {
  final String serviceUrl;

  const _ServiceUrlListTile({required this.serviceUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          "Link Layanan",
          style: const TextStyle(fontWeight: FontWeight.bold)
      ),
      tileColor: Color(0xFFE3F0FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      subtitle: Link(
          uri: Uri.parse(serviceUrl),
          builder: (context, followLink) {
            return GestureDetector(
              onTap: followLink,
              child: Text(
                serviceUrl,
                style: TextStyle(
                  color: Colors.blue.shade900,
                  decoration: TextDecoration.underline,
                ),
              ),
            );
          }
      ),
    );
  }
}

class _AddressListTile extends StatelessWidget {
  final String address;
  const _AddressListTile({required this.address});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          "Alamat",
          style: const TextStyle(fontWeight: FontWeight.bold)
      ),
      tileColor: Color(0xFFE3F0FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      subtitle: Text(address),
    );
  }
}

class _OperationalHourListTile extends StatelessWidget {
  final Map<String, dynamic> operationalHour;
  static const List<String> days =
  ['senin', 'selasa', 'rabu', 'kamis', 'jumat', 'sabtu', 'minggu'];

  const _OperationalHourListTile({required this.operationalHour});

  @override
  Widget build(BuildContext context) {
    final sortedOperationalHourKeys = operationalHour.keys.toList()..sort((a, b) => days.indexOf(a).compareTo(days.indexOf(b)));

    Map<String, dynamic> sortedOperationalHour = {
      for (var key in sortedOperationalHourKeys) key: operationalHour[key]!
    };

    return ListTile(
      title: Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
        child: Text(
            "Jam Operasional",
            style: const TextStyle(fontWeight: FontWeight.bold)
        ),
      ),
      tileColor: Color(0xFFE3F0FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          for (int i = 0; i < sortedOperationalHour.length; i += 2) ...[
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildGridItem(sortedOperationalHour.entries.elementAt(i)),
                  ),

                  // This acts as your crossAxisSpacing!
                  const SizedBox(width: 8.0),

                  // COLUMN 2
                  // We must check if an odd item exists before rendering it
                  Expanded(
                    child: (i + 1 < sortedOperationalHour.length)
                        ? _buildGridItem(sortedOperationalHour.entries.elementAt(i + 1))
                        : const SizedBox.shrink(), // Empty space if there's an odd number of items
                  ),
                ]
            )
          ]
        ],
      ),
    );
  }

  Widget _buildGridItem(MapEntry<String, dynamic> entry) {
    return Container(
      // We add constraints so it doesn't shrink to 0 if empty, but can grow infinitely
      constraints: const BoxConstraints(minHeight: 40),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Hugs the text tightly!
        children: [
          Text(
            entry.key.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(entry.value.toString()),
        ],
      ),
    );
  }
}

class _SocialMediaListTile extends StatelessWidget {
  final Map<String, dynamic> socialMedia;
  const _SocialMediaListTile({required this.socialMedia});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          "Media Sosial",
          style: const TextStyle(fontWeight: FontWeight.bold)
      ),
      tileColor: Color(0xFFE3F0FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              spacing: 4.0,
              children: [
                for (var entry in socialMedia.entries) ...[
                  Link(
                      uri: Uri.parse(entry.value),
                      builder: (context, followLink) {
                        return IconButton(
                            onPressed: followLink,
                            icon: switch (entry.key) {
                              'facebook' => FaIcon(FontAwesomeIcons.facebook, semanticLabel: 'facebook: ${entry.value}'),
                              'youtube' => FaIcon(FontAwesomeIcons.youtube, semanticLabel: 'youtube: ${entry.value}'),
                              'twitter' => FaIcon(FontAwesomeIcons.twitter, semanticLabel: 'twitter: ${entry.value}'),
                              'instagram' => FaIcon(FontAwesomeIcons.instagram, semanticLabel: 'instagram: ${entry.value}'),
                              'tiktok' => FaIcon(FontAwesomeIcons.tiktok, semanticLabel: 'tiktok: ${entry.value}'),
                              _ => const Icon(Icons.link)
                            },
                          color: Color(0xFF0047B3)
                        );
                      }
                  )
                ]
              ]
          )
      ),
    );
  }
}