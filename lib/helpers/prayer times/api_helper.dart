import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerTimesAPI {
  final String _baseUrl = 'https://api.aladhan.com/v1/timingsByCity';

  Future<Map<String, dynamic>> fetchPrayerTimes({
    required String city,
    required String country,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'city': city,
      'country': country,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      if (decodedResponse.containsKey('data') &&
          decodedResponse['data'].containsKey('timings')) {
        // Extract prayer timings
        final timings = Map<String, dynamic>.from(decodedResponse['data']['timings']);

        // Extract Hijri date
        final hijriDate = decodedResponse['data']['date']['hijri'];

        // Combine timings and Hijri date into a single map
        return {
          'timings': timings,
          'hijriDate': hijriDate,
        };
      } else {
        throw Exception('Invalid API response: Timings data not found.');
      }
    } else {
      throw Exception('Failed to load prayer times: ${response.reasonPhrase}');
    }
  }
}