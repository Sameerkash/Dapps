
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_lucky_dapp/root.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'ipfs/ipfs.wrapper.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({Key? key}) : super(key: key);

  @override
  _FileUploadState createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  late Client httpClient;
  late Web3Client ethClient;

  /// url of Ganache instance
  String rpcUrl = 'http://0.0.0.0:7545';
  File? file;
  String? fileName;

  List<dynamic> files = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  void upload(File? file) async {
    print(file);
  }

  Future<void> init() async {
    await initialSetup("FileUpload.json");
    await getContractFunctions();
    await getFi();
  }

  /// Declare contract instance
  late DeployedContract contract;

  /// Declare contract functions
  late ContractFunction getFiles, storeFile;

  Future<void> getFi() async {
    final result = await readContract(getFiles, [], contract);
    print(result);

    setState(() {
      files = result[0];
    });
  }

  Future<void> addFile() async {
    final result = await IPFS.instance.add(file!.path, fileName!);
    final String hash = result['Hash'];
    await writeContract(storeFile, [fileName, hash], contract);
    getFi();

    setState(() {
      file = null;
    });
  }

  Future<void> getContractFunctions() async {
    contract = DeployedContract(
        ContractAbi.fromJson(abi, "FileUpload"), contractAddress);

    storeFile = contract.function('storeFile');
    getFiles = contract.function('getFiles');
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
      body: RefreshIndicator(
        onRefresh: () {
          return getFi();
        },
        child: SingleChildScrollView(
          child: Column(
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
                    addFile();
                  },
                  child: Text("Upload file"),
                ),
              // if (file != null) Text(latestHash!),
              Container(),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your Files",
                      style: TextStyle(color: Colors.grey, fontSize: 25),
                    )),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(files[index][0]),
                  subtitle: Text(files[index][1]),
                  leading: IconButton(
                    onPressed: () {
                      IPFS.instance.download(files[index][0], files[index][1]);
                    },
                    icon: Icon(Icons.download),
                  ),
                ),
                itemCount: files.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
