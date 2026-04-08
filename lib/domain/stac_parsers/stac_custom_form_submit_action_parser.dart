import 'package:dio/dio.dart';
import 'package:stac/stac.dart';
import 'package:flutter/material.dart';

import 'package:majadigi_mobile/domain/stac_build_runner/stac_custom_form_submit_action/stac_custom_form_submit_action.dart';

class StacCustomFormSubmitActionParser extends StacActionParser<StacCustomFormSubmitAction> {
  const StacCustomFormSubmitActionParser();

  @override
  String get actionType => 'formSubmitAction';

  @override
  StacCustomFormSubmitAction getModel(Map<String, dynamic> json) =>
      StacCustomFormSubmitAction.fromJson(json);

  @override
  Future<void> onCall(BuildContext context, StacCustomFormSubmitAction model) async {
    final formData = StacFormScope.of(context)?.formData ?? {};

    final payload = <String, dynamic>{};
    for (final formId in model.formIds) {
      if (formData[formId] == null) {
        continue;
      }

      payload[formId] = formData[formId];
    }

    try {
      Stac.onCallFromJson(
        StacNavigateAction(
          request: StacNetworkRequest(
            url: model.nextPageUrl,
            method: Method.get,
            queryParameters: payload,
          ),
          navigationStyle: NavigationStyle.push,
        ).toJson(),
        context
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data);
    }
  }
}