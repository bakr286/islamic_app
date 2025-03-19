import 'package:flutter/material.dart';
import 'package:islamic_app/data/prayer_times_data.dart';
import 'api_helper.dart';
import 'database.dart';

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
    } catch (e) {
      // Handle error, maybe show a snackbar here if needed.
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPrayerTimes(BuildContext context) async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading prayer times: $e')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}