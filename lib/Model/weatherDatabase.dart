import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_app_flutter/Model/weather_model.dart';

class WeatherDatabase {
  static final WeatherDatabase instance = WeatherDatabase._init();

  static Database? _database;

  WeatherDatabase._init();

  Future<Database> get database async => _database ??= await _initDB();

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'weather.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Weather (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityName TEXT,
        weatherCondition TEXT,
        temperature REAL
      )
      ''');
  }

  Future<Weather> insert(Weather weather) async {
    final db = await instance.database;
    weather.id = await db.insert('Weather', weather.toMap());
    return weather;
  }

  Future<Weather> get(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'Weather',
      columns: WeatherField.values.map((e) => describeEnum(e)).toList(),
      where: '${WeatherField.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Weather.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Weather>> getAll() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('weather');
    return List.generate(maps.length, (i) {
      return Weather.fromMap(maps[i]);
    });
  }

  Future<void> update(Weather weather) async {
    final db = await instance.database;

    await db.update(
      'Weather',
      weather.toMap(),
      where: '${WeatherField.id} = ?',
      whereArgs: [weather.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await instance.database;

    await db.delete(
      'Weather',
      where: '${WeatherField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await instance.database;

    await db.delete('Weather');
  }
}

enum WeatherField {
  id, cityName, weatherCondition, temperature
}

extension WeatherFieldExtension on WeatherField {
  String get value => describeEnum(this);
}
