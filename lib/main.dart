import 'package:flutter/material.dart';
import 'package:islamic_app/helpers/prayer times/times_provider.dart';
import 'package:islamic_app/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'data/themes.dart';
import 'helpers/notifications/schedule_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initializeNotification();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PrayerTimesProvider(),
      child: MaterialApp(
        title: 'Islamic App', 
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: HomeScreen(),
      ),
    );
  }
}
