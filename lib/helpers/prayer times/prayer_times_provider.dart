import 'package:flutter/material.dart';
import 'package:islamic_app/data/prayer_times_data.dart';

import 'prayer_times_api.dart';
import 'prayer_times_save.dart';


class PrayerTimesProvider extends ChangeNotifier {
  final PrayerTimesAPI _prayerTimesAPI = PrayerTimesAPI();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Map<String, dynamic> _prayerTimes = {};
  String city = '';
  String country = '';
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isLoading = false;
  List<MapEntry<String, dynamic>> _loadedTimes = [];
  dynamic _hijriDate;

  TextEditingController get cityController => _cityController;
  TextEditingController get countryController => _countryController;

  Map<String, dynamic> get prayerTimes => _prayerTimes;
  bool get isLoading => _isLoading;
  List<MapEntry<String, dynamic>> get loadedTimes => _loadedTimes;
  dynamic get hijriDate => _hijriDate;

  PrayerTimesProvider() {
    _loadSavedPrayerTimes();
  }

  Future<void> _loadSavedPrayerTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _prayerTimes = await _databaseHelper.getPrayerTimes();
      _loadedTimes = _prayerTimes.entries
          .where((entry) => prayerNames.containsKey(entry.key))
          .toList();
      _hijriDate = _prayerTimes['hijriDate'];
    } catch (e) {
      // Handle error, maybe show a snackbar
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPrayerTimes() async {
    _isLoading = true;
    notifyListeners();

    city = _cityController.text;
    country = _countryController.text;

    try {
      _prayerTimes = await _prayerTimesAPI.fetchPrayerTimes(
        city: city,
        country: country,
      );
      await _databaseHelper.insertPrayerTimes(city, country, _prayerTimes);

      _loadedTimes = _prayerTimes.entries
          .where((entry) => prayerNames.containsKey(entry.key))
          .toList();

      _hijriDate = _prayerTimes['hijriDate'];
    } catch (e) {
      // Handle error, maybe show a snackbar
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}