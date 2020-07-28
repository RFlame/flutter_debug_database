///
///    author : TaoTao
///    date   : 2020/7/22 1:34 PM
///    desc   :
///
class ServerSocketUtils {

  static String detectMimeType(String fileName) {
    String mimeType;
    if(fileName?.endsWith('.html') == true) {
      mimeType = 'text/html';
    } else if(fileName?.endsWith('.js') == true) {
      mimeType = 'application/javascript';
    } else if(fileName?.endsWith('.css') == true) {
      mimeType = 'text/css';
    } else {
      mimeType = 'application/octet-stream';
    }
    return mimeType;
  }
}