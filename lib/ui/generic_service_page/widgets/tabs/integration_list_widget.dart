import 'package:flutter/material.dart';

import 'package:majadigi_mobile/data/model/supabase/integration_list_model.dart';

class IntegrationListWidget extends StatelessWidget {
  final List<IntegrationListModel> data;
  const IntegrationListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text("Tester");
  }
}