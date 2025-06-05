import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_app/data/prayer_times_data.dart';
import 'package:islamic_app/helpers/notifications/schedule_notifications.dart';
import 'api_helper.dart';
import 'database.dart';

class PrayerTimesProvider extends ChangeNotifier {
  final PrayerTimesAPI _prayerTimesAPI = PrayerTimesAPI();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();
  Map<String, dynamic> _prayerTimes = {};
  String _city = '';
  String _country = '';
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isLoading = false;
  List<MapEntry<String, dynamic>> _loadedTimes = [];
  dynamic _hijriDate;

  TextEditingController get cityController => _cityController;
  TextEditingController get countryController => _countryController;

  Map<String, dynamic> get prayerTimes => _prayerTimes;
  bool get isLoading => _isLoading;
  String get getCity => _city;
  String get getCountry => _country;
  List<MapEntry<String, dynamic>> get loadedTimes => _loadedTimes;
  dynamic get hijriDate => _hijriDate;

  PrayerTimesProvider() {
    _notificationService.initializeNotification();
    loadSavedPrayerTimes();
  }

  Future<void> loadSavedPrayerTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _prayerTimes = await _databaseHelper.getPrayerTimes();
      _loadedTimes = _prayerTimes.entries
          .where((entry) => prayerNames.containsKey(entry.key))
          .toList();
      _hijriDate = _prayerTimes['hijriDate'];
      _city = _prayerTimes['city'] ?? '';
      _country = _prayerTimes['country'] ?? '';
      _cityController.text = _city;
      _countryController.text = _country;
    } catch (e) {
      SnackBar(content: Text('Error loading saved prayer times'));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPrayerTimes(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    _city = _cityController.text;
    _country = _countryController.text;

    try {
      // Fetch the full API response.
      final response = await _prayerTimesAPI.fetchPrayerTimes(
        city: _city,
        country: _country,
      );
      // Extract only the 'timings' map so that each prayer time is a String.
      _prayerTimes = response['timings'] as Map<String, dynamic>;
      // Also extract hijriDate if needed.
      _hijriDate = response['hijriDate'];

      // Save data to the database if that’s part of your flow.
      await _databaseHelper.insertPrayerTimes(_city, _country, response);

      _loadedTimes = _prayerTimes.entries
          .where((entry) => prayerNames.containsKey(entry.key))
          .toList();

      // Schedule notifications with the correctly typed prayer times.
      _scheduleNotifications(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading prayer times: $e')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _scheduleNotifications(BuildContext context) async {
    // Cancel existing notifications
    await _notificationService.cancelAllNotifications();

    // Schedule new notifications
    int id = 0; // Use a unique ID for each notification
    _prayerTimes.forEach((prayerName, prayerTime) {
      if (prayerNames.containsKey(prayerName) && prayerName != 'Sunrise' && prayerName != 'Sunset' && prayerName != 'Imsak') {
        try {
          final now = DateTime.now();
          final timeFormat = DateFormat("HH:mm");
          final prayerDateTime = timeFormat.parse(prayerTime);
          final scheduledDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            prayerDateTime.hour,
            prayerDateTime.minute,
          );

          if (scheduledDateTime.isAfter(now)) {
            _notificationService.schedulePrayerNotification(
              prayerTime: scheduledDateTime,
              prayerName: prayerName,
              id: id++,
            );
            print('Notification scheduled for $prayerName at ${timeFormat.format(scheduledDateTime)}'); // Add this line
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error scheduling notification for $prayerName: $e')),
          );
        }
      }
    });
  }
}