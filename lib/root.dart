import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

late Client httpClient;
late Web3Client ethClient;
String rpcUrl = 'http://0.0.0.0:7545';

Future<void> initialSetup(String abiName) async {
  // Initialize the HTTP client.
  httpClient = Client();

// Initialize web3 client
  ethClient = Web3Client(rpcUrl, httpClient);

  await getCredentials();
  await getDeployedContract(abiName);
}

/// globally scoped variables
String _privateKey =
    '0cab7a67362eb841efb842af74c5b8208558b452cbed8cff316c221a9c744222';
late Credentials credentials;
late EthereumAddress myAddress;

/// abi instance
late String abi;
late EthereumAddress contractAddress;

Future<void> getCredentials() async {
  credentials = await ethClient.credentialsFromPrivateKey(_privateKey);
  myAddress = await credentials.extractAddress();
}

Future<void> getDeployedContract(String fileName) async {
  String abiString = await rootBundle.loadString('abi/$fileName');
  var abiJson = jsonDecode(abiString);
  abi = jsonEncode(abiJson['abi']);

  /// Get the contract address from the deployed contract
  contractAddress =
      EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
}

/// Method to read the contract
Future<List<dynamic>> readContract(ContractFunction functionName,
    List<dynamic> functionArgs, DeployedContract contract) async {
  var queryResult = await ethClient.call(
    contract: contract,
    function: functionName,
    params: functionArgs,
  );

  return queryResult;
}

// Method to write to the contract
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
