import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';

import '../data/prayer_times_data.dart';

class PrayerTime extends StatelessWidget {
  const PrayerTime({
    super.key,
    required this.prayerName,
    required this.prayerTime,
  });

  final String prayerName;
  final String prayerTime;

  String _formatTime(String time) {
    try {
      final parsedTime = DateFormat('HH:mm').parse(time);
      return DateFormat('jm').format(parsedTime); // jm provides am/pm
    } catch (e) {
      return time; // Return original time if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: GradientBoxBorder(
          width: 1.8,
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(prayerIcons[prayerName] ?? Icons.access_time),
        title: Text(prayerNames[prayerName] ?? prayerName),
        trailing: Text(_formatTime(prayerTime), style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
