import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/policy/policy_entity.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/widgets/dynamic_json_to_text_renderer.dart';

// Both benefit and instruction is optional in database

class PolicyListWidget extends StatelessWidget {
  final List<PolicyEntity> data;
  const PolicyListWidget({super.key, required this.data});

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
              // Manfaat
              if (entry.benefit != null) ...{
                _BenefitExpansionTile(benefit: entry.benefit!),
              },

              // Instruksi
              if (entry.instruction != null) ...{
                _InstructionExpansionTile(instruction: entry.instruction!),
              }
            ],
          );
        },
      ),
    );
  }
}

class _BenefitExpansionTile extends StatelessWidget {
  final dynamic benefit;
  const _BenefitExpansionTile({required this.benefit});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
          "Manfaat",
          style: const TextStyle(fontWeight: FontWeight.bold)
      ),
      backgroundColor: Colors.grey.shade200,
      collapsedBackgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      childrenPadding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      children: [
        if (benefit is Map)
          for (var entry in benefit.entries) ...[
            DynamicJsonToTextRenderer(data: entry.value)
          ]
        else
          DynamicJsonToTextRenderer(data: benefit)
      ],
    );
  }
}

class _InstructionExpansionTile extends StatelessWidget {
  final dynamic instruction;
  const _InstructionExpansionTile({required this.instruction});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
          "Sistem, Mekanisme & Prosedur",
          style: const TextStyle(fontWeight: FontWeight.bold)
      ),
      backgroundColor: Colors.grey.shade200,
      collapsedBackgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      childrenPadding: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 16.0),
      children: [
        if (instruction is Map)
          for (var entry in instruction.entries) ...[
            DynamicJsonToTextRenderer(data: entry.value)
          ]
        else
          DynamicJsonToTextRenderer(data: instruction)
      ],
    );
  }
}