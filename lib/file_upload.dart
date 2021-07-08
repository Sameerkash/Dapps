import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ipfs/ipfs.wrapper.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({Key? key}) : super(key: key);

  @override
  _FileUploadState createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  File? file;
  String? fileName;

  String? latestHash = "";

  @override
  void initState() {
    super.initState();
  }

  void upload(File? file) async {
    // try {
    // final bytes = file.readAsBytesSync();

    print(file);

    // print(addRes.body!.toJson());

    final addRes = await IPFS.instance.add(file!.path..split(".").first, fileName!);
    // print(addRes.body!.toJson());
    // print(bytes);

    setState(() {
      // latestHash = addRes.body!.hash;
    });
    // } catch (e) {
    //   print(e);
    // }
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File f = File(result.files.single.path!);
      setState(() {
        file = f;
        fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IPFS File Upload"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: file == null
                ? Container(
                    alignment: Alignment.center,
                    height: 250,
                    width: 250,
                    child: Text("File will be displayed here"),
                  )
                : Container(
                    alignment: Alignment.center,
                    height: 250,
                    width: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (file!.path.contains('.jpg') ||
                            file!.path.contains('.png') ||
                            file!.path.contains('.jpeg'))
                          Image.file(file!)
                        else
                          Text(fileName!)
                      ],
                    ),
                  ),
          ),
          TextButton(
            onPressed: () {
              pickFile();
            },
            child: Text("Select File"),
          ),
          SizedBox(height: 20),
          if (file != null)
            TextButton(
              onPressed: () {
                upload(file!);
              },
              child: Text("Upload file"),
            ),
          if (file != null) Text(latestHash!),
          Container()
        ],
      ),
    );
  }
}
