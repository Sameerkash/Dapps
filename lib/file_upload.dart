import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({Key? key}) : super(key: key);

  @override
  _FileUploadState createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IPFS File Upload"),
      ),
      body: Column(
        children: [
          Container(),
        ],
      ),
    );
  }
}
