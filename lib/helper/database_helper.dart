import 'dart:io';

import 'package:football_player_contact/models/contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Ref: https://pub.dev/packages/sqflite
///
class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  final String _db = "CONTACT_DB";
  final String _table = "CONTACT_TABLE";
  final String _colId = "id";
  final String _colName = "name";
  final String _colMobile = "mobile";
  final String _colEmail = "email";
  final String _colFavorite = "favorite";
  final int _version = 1;

  String _pathDatabase = "";

  String get pathDatabase => _pathDatabase;

  Future<Database> get database async {
    return _database ??= await initDatabase();
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    _pathDatabase = "${directory.path}/$_db.db";

    var database = await openDatabase(_pathDatabase,
        version: _version, onCreate: _createDatabase);

    return database;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE $_table (
    $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
    $_colName TEXT,
    $_colMobile TEXT,
    $_colEmail TEXT,
    $_colFavorite INTEGER
    )
   ''');
  }

  Future<int> insert(Contact contact) async {
    var db = await database;

    // contact.toMap();
    Map<String, Object> insertValue = {
      _colName: contact.name,
      _colMobile: contact.mobileNo,
      _colEmail: contact.email,
      _colFavorite: contact.favorite
    };

    var result = await db.insert(_table, insertValue);
    return result;
  }

  Future<int> delete(int id) async {
    var db = await database;

    // db.rawDelete('DELETE FROM $_table WHERE $_colId = ?', [id]);

    var effectRow = await db.delete(
      _table,
      where: '$_colId = ?',
      whereArgs: [id],
    );
    return effectRow;
  }

  Future<int> update(Contact model) async {
    var db = await database;

    var effectRow = await db.update(
      _table,
      model.toMap(),
      where: '$_colId = ?',
      whereArgs: [model.id],
    );

    return effectRow;
  }

  Future<int> updateFavorite(int id, int favorite) async {
    var db = await database;

    var updateValue = {
      _colFavorite: favorite,
    };

    var effectRow = await db.update(
      _table,
      updateValue,
      where: '$_colId = ?',
      whereArgs: [id],
    );

    return effectRow;
  }

  Future<Contact?> getContactById(int id) async {
    var db = await database;

    var contactMap = await db.query(
      _table,
      columns: [_colId, _colName, _colMobile, _colEmail, _colFavorite],
      where: '$_colId = ?',
      whereArgs: [id],
    );

    if (contactMap.isNotEmpty) {
      return Contact.fromMap(contactMap.first);
    }

    return null;
  }

  Future<List<Contact>> getContacts() async {
    var db = await database;

    List<Contact> contacts = [];

    // db.rawQuery("SELECT * FROM $_table");
    var contactsMap = await db.query(
      _table,
      columns: [_colId, _colName, _colMobile, _colEmail, _colFavorite],
    );

    for (var contact in contactsMap) {
      contacts.add(Contact.fromMap(contact));
    }

    return contacts;
  }

  Future<void> close() async {
    var db = await database;
    db.close();
  }
}
