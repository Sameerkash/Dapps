import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  TextEditingController text = new TextEditingController();
  late Client httpClient;
  late Web3Client ethClient;
  String rpcUrl = 'http://0.0.0.0:7545';

  String name = "";

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  Future<void> initialSetup() async {
    httpClient = Client();
    ethClient = Web3Client(rpcUrl, httpClient);

    await getCredentials();
    await getDeployedContract();
    await getContractFunctions();

    await getN();
  }

  Future<void> getN() async {
    final result = await readContract(getName, []);

    print(result);

    setState(() {
      name = result.first;
    });
  }

  String privateKey =
      '7833c936550ca689f821e372260475516acd6cae8b4b239d03871edcf1c5cd49';
  late Credentials credentials;
  late EthereumAddress myAddress;

  Future<void> getCredentials() async {
    credentials = await ethClient.credentialsFromPrivateKey(privateKey);
    myAddress = await credentials.extractAddress();
  }

  late String abi;
  late EthereumAddress contractAddress;

  Future<void> getDeployedContract() async {
    String abiString = await rootBundle.loadString('abi/Example.json');
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
  }

  late DeployedContract contract;
  late ContractFunction getName, setName;

  Future<void> getContractFunctions() async {
    contract =
        DeployedContract(ContractAbi.fromJson(abi, "Example"), contractAddress);

    getName = contract.function('getName');
    setName = contract.function('setName');
  }

  Future<List<dynamic>> readContract(
    ContractFunction functionName,
    List<dynamic> functionArgs,
  ) async {
    var queryResult = await ethClient.call(
      contract: contract,
      function: functionName,
      params: functionArgs,
    );

    return queryResult;
  }

  Future<void> writeContract(
    ContractFunction functionName,
    List<dynamic> functionArgs,
  ) async {
    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: functionName,
        parameters: functionArgs,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return getN();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Ethereum-icon-purple.svg/1200px-Ethereum-icon-purple.svg.png"),
                height: 300,
                width: 300,
              ),
              Container(),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      gapPadding: 20,
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (text.value.text.isNotEmpty)
                    await writeContract(setName, [text.value.text]);
                },
                child: Text("Change"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
