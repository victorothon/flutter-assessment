import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:auxo_flights/api_services/flights_service.dart';

Future<Database> openMyDatabase() async {
  final tableItineraries = 'itineraries';
  final tableLegs = 'legs';
  final tableAirlines = 'airlines';

  final dbPath = await getDatabasesPath().then((value) => value);
  final path = join(dbPath, 'Flights.db');
  final database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
              CREATE TABLE $tableItineraries (
                id TEXT PRIMARY KEY,
                legs TEXT,
                price INTEGER,
                agent TEXT,
                agent_rating REAL
              )
              ''');
      await db.execute('''
              CREATE TABLE $tableLegs (
                id TEXT PRIMARY KEY,
                departure_airport TEXT,
                arrival_airport TEXT,
                departure_time TEXT,
                arrival_time TEXT,
                stops INTEGER,
                airline_id TEXT,
                duration_mins INTEGER
              )
              ''');
      await db.execute('''
              CREATE TABLE $tableAirlines (
                id TEXT PRIMARY KEY,
                name TEXT
              )
              ''');
    },
  );
  return database;
}

class DatabaseHelper {
  static final _databaseName = "Flights.db";
  static final _databaseVersion = 1;

  static final tableItineraries = 'itineraries';
  static final tableLegs = 'legs';
  static final tableAirlines = 'airlines';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    String path = join(await getDatabasesPath().then((value) => value), _databaseName);
    return await openDatabase(path,
      version: _databaseVersion,
      onCreate: _oncreate );
  }
        
  _oncreate(Database db, int version) async {
      db.execute('''
        CREATE TABLE $tableItineraries (
          id TEXT PRIMARY KEY,
          legs TEXT,
          price INTEGER,
          agent TEXT,
          agent_rating REAL
        )
        ''');
      db.execute('''
        CREATE TABLE $tableLegs (
          id TEXT PRIMARY KEY,
          departure_airport TEXT,
          arrival_airport TEXT,
          departure_time TEXT,
          arrival_time TEXT,
          stops INTEGER,
          airline_id TEXT,
          duration_mins INTEGER
        )
        ''');
      db.execute('''
        CREATE TABLE $tableAirlines (
          id TEXT PRIMARY KEY,
          name TEXT
        )
        ''');
    }

  //initial populate the tables
  Future<void> populateTables() async {
    var flightService = FlightService();
    var data = await flightService.fetchFlights();

    for (var itinerary in data['itineraries']) {
      await insertOrUpdate(itinerary.toMap(), tableItineraries, 'id');
    }
    for (var leg in data['legs']) {
      await insertOrUpdate(leg.toMap(), tableLegs, 'id');
    }
    for (var airline in data['airlines']) {
      await insertOrUpdate(airline.toMap(), tableAirlines, 'id');
    }
  }
  // Database helper methods:
  Future<int> insertOrUpdate(
      Map<String, dynamic> row, String tableName, String idColumn) async {
    Database db = await instance.database;
    var exists = await db
        .query(tableName, where: '$idColumn = ?', whereArgs: [row[idColumn]]);
    if (exists.isEmpty) {
      return await db.insert(tableName, row);
    } else {
      return await db.update(tableName, row,
          where: '$idColumn = ?', whereArgs: [row[idColumn]]);
    }
  }

  Future<List<Map<String, dynamic>>> getItineraries(String? departureAirport, String? arrivalAirport, double price) async {
    final db = await database;
    final List<Map<String, dynamic>> itineraries = await db.query('itineraries', where: 'price <= ?', whereArgs: [price]);

    List<Map<String, dynamic>> result = [];

    for (var itinerary in itineraries) {
      List<String> legIds = itinerary['legs'].split(',');

      String firstLegDepartureAirport = (await db.query('legs', where: 'id = ?', whereArgs: [legIds.first]))[0]['departure_airport'] as String;
      String lastLegArrivalAirport = (await db.query('legs', where: 'id = ?', whereArgs: [legIds.last]))[0]['arrival_airport'] as String;

      if ((departureAirport == null || firstLegDepartureAirport == departureAirport) &&
          (arrivalAirport == null || lastLegArrivalAirport == arrivalAirport)) {
        result.add(itinerary);
      }
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getLegs(String? departureAirport, String? arrivalAirport, int numLegs) async {
    final db = await database;

    // Get all airlineIds
    final List<Map<String, dynamic>> airlines = await db.query(DatabaseHelper.tableAirlines);
    List<String> airlineIds = airlines.map((airline) => airline['id'] as String).toList();

    List<Map<String, dynamic>> result = [];

    for (String airlineId in airlineIds) {
      String whereString = '';
      List<dynamic> whereArgs = [];

      if (departureAirport != null) {
        whereString += 'departure_airport = ? ';
        whereArgs.add(departureAirport);
      }

      if (arrivalAirport != null) {
        if (whereString.isNotEmpty) whereString += 'AND ';
        whereString += 'arrival_airport = ? ';
        whereArgs.add(arrivalAirport);
      }

      if (whereString.isNotEmpty) whereString += 'AND ';
      whereString += 'airline_id = ? AND airline_id IN (SELECT airline_id FROM ${DatabaseHelper.tableLegs} GROUP BY airline_id HAVING COUNT(*) <= ?) ';

      whereArgs.add(airlineId);
      whereArgs.add(numLegs);

      final List<Map<String, dynamic>> legs = await db.query(DatabaseHelper.tableLegs, where: whereString, whereArgs: whereArgs);

      result.addAll(legs);
    }

    return result;
  }

  Future<int> insert(Map<String, dynamic> row, String tableName) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<int> update(Map<String, dynamic> row, String tableName) async {
    Database db = await instance.database;
    return await db
        .update(tableName, row, where: 'id = ?', whereArgs: [row['id']]);
  }

  Future<int> delete(String id, String tableName) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>> queryRow(String tableName, String id) async {
    Database db = await instance.database;
    List<Map> result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return result.first as Map<String, dynamic>;
  }
}
