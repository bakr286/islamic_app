import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/prayer times/times_provider.dart';
import '../models/prayer_time_widget.dart';

class PrayerTimes extends StatelessWidget {
  const PrayerTimes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrayerTimesProvider>(context);

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Edit city and country to get prayer times.',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'City: ${provider.getCity}', // Display selected city
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    'Country: ${provider.getCountry}', // Display selected country
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: provider.cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: provider.countryController,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await provider.getPrayerTimes(context);
              },
              child: const Text('Get Prayer Times'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Prayer Times'),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (provider.hijriDate != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${provider.hijriDate['day']} ${provider.hijriDate['month']['ar']}',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.prayerTimes.isEmpty
                ? const Center(child: Text('Enter city and country'))
                : ListView.builder(
                    itemCount: provider.loadedTimes.length,
                    itemBuilder: (context, index) {
                      final prayerName = provider.loadedTimes[index].key;
                      final prayerTime = provider.loadedTimes[index].value;
                      return PrayerTime(
                        prayerName: prayerName,
                        prayerTime: prayerTime.toString(),
                      );
                    },
                  ),
      ),
    );
  }
}
