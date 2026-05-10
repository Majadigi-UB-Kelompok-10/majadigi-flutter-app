import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/statistic/statistic_entity.dart';

/// Mock Data for Statistics
final List<StatisticEntity> statisticData = [
  StatisticEntity(
    label: 'Jumlah Penduduk',
    value: '42.089.271',
    icon: Icons.people
  ),

  StatisticEntity(
      label: 'Pertumbuhan',
      value: '0,73%',
      icon: Icons.trending_up
  ),

  StatisticEntity(
      label: 'Lainnya',
      value: '9,56%',
      icon: Icons.home
  ),
];