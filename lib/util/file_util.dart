import 'package:http/http.dart' as http;

class FileUtil {
  static String checkFileSizeFromUri(String uri) {
    String fileSize = "";
    Future<http.Response> r = _getResponseHeader(uri);
    r.then((value) => fileSize = value.headers['content-length']!);
    return fileSize;
  }

  static Future<http.Response> _getResponseHeader(String uri) async {
    http.Response response =
        await http.head(Uri.parse(uri)).then((value) => value);
    return response;
  }
}
