import 'package:flutter/material.dart' show IconData;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistic_entity.freezed.dart';

/// Represent Endpoint Entity
@freezed
class StatisticEntity with _$StatisticEntity {
  const StatisticEntity({
    this.label,
    this.value,
    this.icon
  });

  @override
  final String? label;

  @override
  final String? value;

  @override
  final IconData? icon;
}