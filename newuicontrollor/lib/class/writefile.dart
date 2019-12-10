import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:newuicontrollor/class/shareddata.dart';
import 'package:path_provider/path_provider.dart';

class WriteFlie {
  static Future<File> downloadABIFile(String url, String filename) async {
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    print('$dir/$filename');
    await file.writeAsBytes(bytes);
    SharedData.setABIFilePath('$dir/$filename');
    return file;
  }
    static Future<File> downloadKeystoreFile(String url, String filename) async {
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    print('$dir/$filename');
    await file.writeAsBytes(bytes);
    SharedData.setKeystoreFilePath('$dir/$filename');
    return file;
  }
}
