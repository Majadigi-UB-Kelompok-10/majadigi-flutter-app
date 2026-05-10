import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/statistic/statistic_entity.dart';

/// Statistic Widget for Homepage
class HomePageStatistic extends StatelessWidget {
  final List<StatisticEntity> statisticList;
  const HomePageStatistic({super.key, required this.statisticList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _StatisticHeader(title: 'Statistik Jawa Timur'),

        // Cards
        _StatisticCards(statisticList: statisticList),
      ],
    );
  }
}

/// Header for Statistics
class _StatisticHeader extends StatelessWidget {
  final String title;
  const _StatisticHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// Cards items for Statistic
class _StatisticCards extends StatelessWidget {
  final List<StatisticEntity> statisticList;
  const _StatisticCards({super.key, required this.statisticList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        children: [
          for (var stat in statisticList)
            _StatisticCardItem(label: stat.label!, value: stat.value!, icon: stat.icon!)
        ],
      ),
    );
  }
}

class _StatisticCardItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatisticCardItem({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue, size: 35),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
        ],
      ),
    );
  }
}