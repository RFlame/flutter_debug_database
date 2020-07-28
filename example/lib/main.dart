import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_debug_database/flutter_debug_database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var databasesPath = await getDatabasesPath();
  String path1 = join(databasesPath, 'demo.db');
  String path2 = join(databasesPath, 'demo2.db');
  // open the database
  Database database = await openDatabase(path1, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Test01 (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        await db.execute(
            'CREATE TABLE Test02 (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        await db.execute(
            'CREATE TABLE Test03 (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
      });
  await openDatabase(path2, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE demo2Table01 (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        await db.execute(
            'CREATE TABLE demo2Table02 (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        await db.execute(
            'CREATE TABLE demo2Table03 (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
      });
  database.rawInsert('INSERT INTO Test01(name, value, num) VALUES("some name1", 1234, 456.789)');
  database.rawInsert('INSERT INTO Test01(name, value, num) VALUES("some name2", 1235, 456.789)');
  database.rawInsert('INSERT INTO Test01(name, value, num) VALUES("some name3", 1236, 456.789)');
  database.rawInsert('INSERT INTO Test01(name, value, num) VALUES("some name4", 1237, 456.789)');
  database.rawInsert('INSERT INTO Test01(name, value, num) VALUES("some name5", 1238, 456.789)');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _ip = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String ip;
    ip = await NetworkUtils.getIpAddress();

    FlutterDebugDatabase.init();

    if (!mounted) return;

    setState(() {
      _ip = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('ip address: $_ip\n'),
        ),
      ),
    );
  }
}
