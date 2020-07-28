import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_debug_database/src/server/client_server.dart';

class FlutterDebugDatabase {
  static const MethodChannel _channel =
      const MethodChannel('flutter_debug_database');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Map<String, String> allDbPaths = {};

  static config(Map<String, String> map) {
    allDbPaths = map;
  }

  static add(String path) {
    if(allDbPaths == null) {
      allDbPaths = {};
    }
    allDbPaths[path] = path;
  }

  static init() async{
    await ClientServer.start();
  }
}
