import 'dart:convert';

import 'package:http/http.dart' as http;

class IPFS {
  late String url;
  IPFS._() {
    url = "http://127.0.0.1:5001";
  }
  static IPFS instance = IPFS._();

  Future<void> add(String path, String fileName) async {
    Map<String, String> headers = <String, String>{
      "Abspath": "/absolute/path/to/file.txt",
      "Content-Disposition": 'form-data; name="file"; filename="$fileName"',
      "Content-Type": "application/octet-stream"
    };

    var uri = Uri.parse('$url/api/v0/add');
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(
          headers) //if u have headers, basic auth, token bearer... Else remove line
      ..files.add(await http.MultipartFile.fromPath(
        'path',
        '$path',
      ));
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print(jsonDecode(respStr));
  }


  // Future<void> cat() async {



    
  // },
}
