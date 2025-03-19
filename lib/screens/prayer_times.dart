import 'package:flutter/material.dart';
import 'package:islamic_app/widgets/prayer_time_widget.dart';
import 'package:provider/provider.dart';
import '../helpers/prayer times/times_provider.dart';

class PrayerTimes extends StatelessWidget {
  const PrayerTimes({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PrayerTimesProvider(),
      child: Consumer<PrayerTimesProvider>(
        builder: (context, provider, child) {
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
                      await provider.getPrayerTimes(context).then((_) {
                        
    provider.loadSavedPrayerTimes();
                      });
                    },

                    child: const Text('Get Prayer Times'),
                  ),
                ],
              ),
            ),

            appBar: AppBar(
              title: const Text('Prayer Times'),

              centerTitle: true,

              actions: [
                if (provider.hijriDate != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: Text(
                      '${provider.hijriDate['day']} ${provider.hijriDate['month']['ar']}',

                      style: TextStyle(
                        fontSize: 16,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child:
                        provider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : provider.prayerTimes.isEmpty
                            ? const Center(
                              child: Text('Enter city and country'),
                            )
                            : ListView.builder(
                              itemCount: provider.loadedTimes.length,
                              itemBuilder: (context, index) {
                                String prayerName =
                                    provider.loadedTimes[index].key;
                                dynamic prayerTime =
                                    provider.loadedTimes[index].value;
                                return PrayerTime(
                                  prayerName: prayerName,
                                  prayerTime: prayerTime,
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
