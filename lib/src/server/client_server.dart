import 'dart:io';

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_debug_database/flutter_debug_database.dart';
import 'package:flutter_debug_database/src/model/db_response.dart';
import 'package:flutter_debug_database/src/util/server_socket_utils.dart';
import 'package:sqflite/sqflite.dart';
///
///    author : TaoTao
///    date   : 2020/7/20 4:07 PM
///    desc   :
///
class ClientServer {

  static Database database;

  static start() async {
    String ipAddress = await NetworkUtils.getIpAddress();
    int port = 4042;
    print("start ClientServer:http://$ipAddress:$port");
    var serverSocket = await ServerSocket.bind(ipAddress, port);
    print("ClientServer connected");
    /*serverSocket.listen((socket) {
      socket.listen((data) async {
        if (data == RawSocketEvent.read) {
          print(utf8.decode(socket.read()));
          String route = 'index.html';
          String html = await rootBundle.loadString(
              'packages/flutter_debug_database/assets/$route');
          String head = '';
          head = 'HTTP/1.1 200 OK\r\n' +
              'Content-type:${ServerSocketUtils.detectMimeType(route)}\r\n' +
              'Content-Length:${utf8
                  .encode(html)
                  .length}\r\n';
          String web = head + '\r\n' + html;
          socket.write(utf8.encode(web));
        }
      });
    });*/
    //遍历所有连接到服务器的套接字
    await for (var socket in serverSocket) {
      //数据流Stream操作：监听接收到的数据
      utf8.decoder.bind(socket).listen((data) async {
//        print("接收到来自Client的数据：\n$data");
        if (data != null && data.startsWith('GET /')) {
          print('======== begin ========');
          List<int> dataBytes;
          List<String> line = data.split('\n');
          String route;
          if(line != null && line.length > 0) {
            print('line[0]:${line[0]}');
            int start = line[0].indexOf('/') + 1;
            int end = line[0].indexOf(' ', start);
            print('start:$start,end:$end');
            route = line[0].substring(start, end);
          }
          if(route == null || route.isEmpty) {
            route = 'index.html';
          }
          print('route:$route');
          if (route.startsWith("getDbList")) {
            String dbPath = await getDatabasesPath();
            FlutterDebugDatabase.add(dbPath);
            List<List<String>> rows = [];
            for(String path in FlutterDebugDatabase.allDbPaths.values) {
              try {
                var dbDirector = Directory(path);
                List<FileSystemEntity> files = dbDirector.listSync();
                for(FileSystemEntity fileSystemEntity in files) {
                  if(FileSystemEntity.isFileSync(fileSystemEntity.path)) {
                    List<String> dbNames = [];
//                  String fileName = fileSystemEntity.path.split('/').last;
                    print('db fileSystemEntity path:${fileSystemEntity.path}');
                    dbNames.add(fileSystemEntity.path);
                    //TODO 加密数据库处理
                    dbNames.add('false');
                    dbNames.add('true');
                    rows.add(dbNames);
                  }
                }
              } catch(e) {
                continue;
              }
            }

            DBResponse dbResponse = DBResponse();
            dbResponse.isSuccessful = true;
            dbResponse.rows = rows;
            dataBytes = utf8.encode(json.encode(dbResponse.toJson()));
          } else if (route.startsWith("getAllDataFromTheTable")) {
            String tableName;
            if (route.contains("?tableName=")) {
              tableName = route.substring(route.indexOf("=") + 1);
            }
            DBTableDataResponse dataResponse = DBTableDataResponse();
            String sql = "SELECT * FROM " + tableName;
            String quotedTableName = '[$tableName]';
            String pragmaQuery = "PRAGMA table_info($quotedTableName)";
            List<Map> tableMap = await database.rawQuery(pragmaQuery);
            List<TableInfo> tableInfos = [];
            if(tableMap != null && tableMap.length > 0) {
              tableMap.forEach((element) {
                TableInfo tableInfo = TableInfo();
                tableInfo.isPrimary = element['pk'] == 1;
                tableInfo.title = element['name'];
                tableInfos.add(tableInfo);
              });
            }

            dataResponse.tableInfos = tableInfos;

            List<Map> tabViewMap = await database?.rawQuery("SELECT type FROM sqlite_master WHERE name=?", [quotedTableName]);
            bool isView = false;
            if(tabViewMap != null && tabViewMap.length > 0) {
              isView = 'view'.toLowerCase() == tabViewMap[0].toString().toLowerCase();
            }

            dataResponse.isEditable = tableName != null && dataResponse.tableInfos != null && !isView;

            if(tableName != null && tableName.isNotEmpty) {
              sql = sql.replaceAll(tableName, quotedTableName);
            }

            List<Map> columnMap = await database.rawQuery(sql);
            dataResponse.rows = [];
            if(columnMap != null && columnMap.length > 0) {
              columnMap.forEach((element) {
                List<ColumnData> rows = [];
                element.forEach((key, value) {
                  ColumnData columnData = ColumnData();
                  columnData.dataType = key;
                  columnData.value = value;
                  rows.add(columnData);
                });
                dataResponse.rows.add(rows);
              });
            }

            dataResponse.isSuccessful = true;
            dataResponse.isSelectQuery = true;
            dataBytes = utf8.encode(json.encode(dataResponse.toJson()));
          } else if (route.startsWith("getTableList")) {
            String databaseName;
            if(route.contains('?database=')) {
              databaseName = route.substring(route.indexOf('=') + 1);
            }
            if(databaseName.endsWith(".db")) {
//              String dbPath = await getDatabasesPath();
              database = await openDatabase('$databaseName', onCreate: null, onUpgrade: null, onDowngrade: null);
              List<Map> tableList = await database.rawQuery("SELECT name FROM sqlite_master WHERE type='table' OR type='view' ORDER BY name COLLATE NOCASE");

              DBResponse dbResponse = DBResponse();
              dbResponse.dbVersion = await database?.getVersion()??0;
              print('getTableList:$tableList,dbVersion:${dbResponse.dbVersion}');
              dbResponse.isSuccessful = true;
              List<String> tableName = [];
              if(tableList != null && tableList.length > 0) {
                tableList.forEach((tableMap) {
                  tableMap.values.forEach((value) {
                    tableName.add(value);
                  });
                });
              }
              dbResponse.rows = tableName;
              dataBytes = utf8.encode(json.encode(dbResponse.toJson()));
            }
          } else if (route.startsWith("addTableData")) {

          } else if (route.startsWith("updateTableData")) {

          } else if (route.startsWith("deleteTableData")) {

          } else if (route.startsWith("query")) {

          } else if (route.startsWith("deleteDb")) {

          } else if (route.startsWith("downloadDb")) {

          } else {
            try {
              ByteData web = await rootBundle.load('packages/flutter_debug_database/assets/$route');
              dataBytes = web.buffer.asUint8List();
            } catch(e) {
              print(e);
            }
          }
          if(dataBytes == null) {
            socket.writeln("HTTP/1.0 500 Internal Server Error");
            return;
          }
          String contentType = ServerSocketUtils.detectMimeType(route);
          int contentLength = dataBytes.length;
          print('contentType:$contentType, contentLength:$contentLength');
          print('======== end ========');
          socket.writeln('HTTP/1.1 200 OK');
          socket.writeln('Content-Type: $contentType');
          socket.writeln('Content-Length: $contentLength');
          socket.writeln();
          socket.add(dataBytes);
        }
      });
    }
  }

  static stop() {

  }

}