import 'package:majadigi_mobile/data/model/supabase/integration_list_model.dart';
import 'package:majadigi_mobile/data/model/supabase/operational_list_model.dart';
import 'package:majadigi_mobile/data/model/supabase/policy_list_model.dart';

sealed class TabPayload {}

class IntegrationPayload extends TabPayload {
  final List<IntegrationListModel> data;
  IntegrationPayload(this.data);
}

class OperationalPayload extends TabPayload {
  final List<OperationalListModel> data;
  OperationalPayload(this.data);
}

class PolicyPayload extends TabPayload {
  final List<PolicyListModel> data;
  PolicyPayload(this.data);
}