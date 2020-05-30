import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teepme/models/UserModel.dart';

class DBHelper{
  static final DBHelper _instance = new DBHelper.internal();
  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async{
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }
  
  DBHelper.internal();

  initDb() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDB;
  }

  void _onCreate(Database db, int version) async{
    //create db table
    String dbCreate = "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)";
    await db.execute(dbCreate);
    print("crate table: " + dbCreate);
  }

  Future<int> saveUser(UserModel userModel) async{
    var dbClient = await db;
    int res = await dbClient.insert("User", userModel.mapToDbClient());
    return res;
  }

  Future<int> deleteUser() async{
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async{
    var dbClient = await db;
    var res = await dbClient.query("User");
    print("result : " + res.first.toString());
    return res.length > 0 ? true: false;
  }

  Future<UserModel> getData() async{
    var dbClient = await db;
    List<Map> res = await dbClient.query("User");
    return UserModel.fromMap(res.first);
  }

}