import 'package:flutter/services.dart';
import 'package:get_ip/get_ip.dart';

///
///    author : TaoTao
///    date   : 2020/7/20 3:12 PM
///    desc   :
///
class NetworkUtils {

  static Future<String> getIpAddress() async{
    String ipAddress;
    try {
      ipAddress = await GetIp.ipAddress;
    } on PlatformException {
      ipAddress = 'Failed to get ipAddress.';
    }
    return ipAddress;
  }
}