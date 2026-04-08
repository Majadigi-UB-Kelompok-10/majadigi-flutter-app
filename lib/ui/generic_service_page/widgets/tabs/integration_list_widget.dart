import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:majadigi_mobile/ui/dynamic_page/stac_test_page.dart';

import 'package:majadigi_mobile/data/model/supabase/integration_list_model.dart';

class IntegrationListWidget extends StatelessWidget {
  final List<IntegrationListModel> data;
  const IntegrationListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        separatorBuilder: (context, index) => const Divider(height: 12.0),
        itemBuilder: (context, index) {
          final entry = data[index];

          return ListTile(
            leading: entry.iconUrl != null ?
            Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 8.0, horizontal: 4.0),
                child: CachedNetworkImage(
                  imageUrl: entry.iconUrl!,
                  fit: BoxFit.contain,
                  useOldImageOnUrlChange: true,
                  placeholder: (context, idk) => const LinearProgressIndicator(),
                )
            )
                : const Icon(Icons.link),
            title: Text(
                entry.title!,
                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.blue.shade900)
            ),
            tileColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyStacTestPage(pageUrl: entry.pageUrl!))
              );
            },
          );
        },
      ),
    );
  }
}