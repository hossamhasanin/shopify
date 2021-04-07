import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

class GovCitiesDatasource {
  Database? _db;

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "eg_gov_cities.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "eg_gov_cities.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    _db = await openDatabase(path, readOnly: true);
  }

  Future<List<String>> getAllGovs() async {
    if (_db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<Map> govs = [];

    await _db!.transaction((txn) async {
      govs = await txn.query(
        "governorates",
        columns: [
          "governorate_name_en",
        ],
      );
    });

    return govs.map((e) => e["governorate_name_en"].toString()).toList();
  }

  Future<List<String>> getAllCities(int govId) async {
    if (_db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<Map> cities = [];

    await _db!.transaction((txn) async {
      cities = await txn.query("cities",
          columns: [
            "city_name_en",
          ],
          where: "governorate_id = ?",
          whereArgs: [govId]);
    });
    debugPrint("datasorce cities " + cities.toString());
    return cities.map((e) => e["city_name_en"].toString()).toList();
  }

  Future<int> getGovId(String govName) async {
    if (_db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<Map> maps = [];

    await _db!.transaction((txn) async {
      maps = await txn.query("governorates",
          columns: [
            "id",
          ],
          where: "governorate_name_en = ?",
          whereArgs: [govName]);
    });

    print("city gov" + govName);
    print("city " + maps[0]["id"].toString());
    return maps[0]["id"];
  }
}
