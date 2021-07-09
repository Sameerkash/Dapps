import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

late Client httpClient;
late Web3Client ethClient;
String rpcUrl = 'http://0.0.0.0:7545';

Future<void> initialSetup(String abiName) async {
  httpClient = Client();
  ethClient = Web3Client(rpcUrl, httpClient);

  await getCredentials();
  await getDeployedContract(abiName);
}

/// globally scoped variables
String _privateKey =
    '7833c936550ca689f821e372260475516acd6cae8b4b239d03871edcf1c5cd49';
late Credentials credentials;
late EthereumAddress myAddress;
late String abi;
late EthereumAddress contractAddress;

Future<void> getCredentials() async {
  credentials = await ethClient.credentialsFromPrivateKey(_privateKey);
  myAddress = await credentials.extractAddress();
}

Future<void> getDeployedContract(String fileName) async {
  print(fileName);
  String abiString = await rootBundle.loadString('abi/$fileName');
  var abiJson = jsonDecode(abiString);
  abi = jsonEncode(abiJson['abi']);

  contractAddress =
      EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
}

Future<List<dynamic>> readContract(ContractFunction functionName,
    List<dynamic> functionArgs, DeployedContract contract) async {
  var queryResult = await ethClient.call(
    contract: contract,
    function: functionName,
    params: functionArgs,
  );

  return queryResult;
}

Future<void> writeContract(ContractFunction functionName,
    List<dynamic> functionArgs, DeployedContract contract) async {
  await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: functionName,
      parameters: functionArgs,
    ),
  );
}
