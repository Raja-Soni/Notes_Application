import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbConnection{
  static final String TABLE_NAME="notes";
  static final String COLUMN_NAME_ID="id";
  static final String COLUMN_NAME_NOTE="note";

  DbConnection._();
  static final DbConnection dbConnection = DbConnection._();
  Database? sqfDb;

  Future<Database> getDB() async {
    sqfDb ??= await openDB();
    return sqfDb!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path,"notesDB.db");
    //   await File(dbPath).delete();
    return await openDatabase(dbPath, version: 1,
    onCreate: (db,version) async{
    await db.execute('CREATE TABLE $TABLE_NAME($COLUMN_NAME_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_NAME_NOTE TEXT NOT NULL)');
    });
  }

  Future<int> addNewNote({required String note}) async{
    var connectedDB= await getDB();
    return await connectedDB.insert(TABLE_NAME, {COLUMN_NAME_NOTE:note});
  }

  Future<List<Map<String,dynamic>>> getAllData()async{
    var connectedDB= await getDB();
    return await connectedDB.query(TABLE_NAME, columns:[COLUMN_NAME_NOTE,COLUMN_NAME_ID]);
  }

  Future<int> deleteNote({required int notePosition})async{
    var connectedDB= await getDB();
    return await connectedDB.delete(TABLE_NAME,where:'$COLUMN_NAME_ID=$notePosition');
  }

  Future<int> updateNote({required int notePosition, required String updatedNote})async{
    var connectedDB= await getDB();
    return connectedDB.update(TABLE_NAME,{COLUMN_NAME_NOTE:updatedNote}, where:'$COLUMN_NAME_ID=$notePosition');
  }
}