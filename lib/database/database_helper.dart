import 'package:pry_20220140/models/data_models/detection_data_model.dart';
import 'package:pry_20220140/models/data_models/report_data_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final DatabaseHelper _context = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  static Database? _db;
  final String tableName = "detection";
  final _version = 1;

  static DatabaseHelper get instance => _context;

  Future<Database> get database async => _db ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return await openDatabase(await getDatabasesPath() + "/detection.db",
        version: _version, onCreate: (Database db, int version) async {
      await db.execute('''
            create table $tableName ( 
              detection_id integer primary key autoincrement, 
              accuracy text not null,
              label text not null,
              timestamp datetime default CURRENT_TIMESTAMP)
            ''');
    });
  }

  void insert(DetectionDataModel detectionDataModel) async {
    await (await database).insert(tableName, detectionDataModel.toMap());
  }

  // Future<bool> getAll() async {
  //   List<Map> rawResult = await (await database).query(tableName);

  //   return true;
  //   // rawResult.map((result) => DetectionDataModel(result["accuracy"], result[""]))
  // }

  Future<List<DetectionTotalModel>> getSummary(DateTime date) async {
    // var formattedDate = "2022-09-24";
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    List<Map> rawResult = await (await database).rawQuery("SELECT label, count(*) total FROM $tableName WHERE date(timestamp, 'localtime') = '$formattedDate' GROUP BY label");
    // List<Map> rawResult = await (await database).query(tableName,
    //     columns: ["label", "COUNT(*) as total"],
    //     groupBy: "label",
    //     where: "date(timestamp) = ?",
    //     whereArgs: ["${date.year}-${date.month}-${date.day}"]);

    return rawResult
        .map((result) => DetectionTotalModel(result["label"], result["total"]))
        .toList();
    // rawResult.map((result) => DetectionDataModel(result["accuracy"], result[""]))
  }
}
