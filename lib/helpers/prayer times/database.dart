import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'prayer_times.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE prayer_times(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city TEXT,
        country TEXT,
        prayer_name TEXT,
        prayer_time TEXT,
        hijri_day INTEGER,
        hijri_month TEXT
      )
    ''');
  }

  Future<void> insertPrayerTimes(
      String city, String country, Map<String, dynamic> prayerTimes) async {
    final db = await database;
    await db.delete('prayer_times');

    final timings = prayerTimes['timings'] as Map<String, dynamic>;
    final hijriDate = prayerTimes['hijriDate'] as Map<String, dynamic>;

    for (var entry in timings.entries) {
      await db.insert(
        'prayer_times',
        {
          'city': city,
          'country': country,
          'prayer_name': entry.key,
          'prayer_time': entry.value.toString(),
          'hijri_day': hijriDate['day'],
          'hijri_month': hijriDate['month']['ar'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Map<String, dynamic>> getPrayerTimes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('prayer_times');

    if (maps.isEmpty) return {};

    Map<String, dynamic> prayerTimes = {};
    Map<String, dynamic> hijriDate = {};

    // Fetch hijri date separately
    final List<Map<String, dynamic>> hijriMaps = await db.query(
      'prayer_times',
      columns: ['hijri_day', 'hijri_month'],
      limit: 1,
    );

    if (hijriMaps.isNotEmpty) {
      hijriDate['day'] = hijriMaps[0]['hijri_day'];
      hijriDate['month'] = {'ar': hijriMaps[0]['hijri_month']};
    }

    for (var map in maps) {
      prayerTimes[map['prayer_name']] = map['prayer_time'];
    }

    if (hijriDate.isNotEmpty) {
      prayerTimes['hijriDate'] = hijriDate;
    }

    return prayerTimes;
  }
}