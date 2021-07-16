import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_lucky_dapp/root.dart';
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
    init();
    super.initState();
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  Future<void> init() async {
    await initialSetup("Example.json");
    await getContractFunctions();
    await getN();
  }

  /// Declare contract instance
  late DeployedContract contract;

  /// Declare contract functions
  late ContractFunction getName, setName;

  Future<void> getN() async {
    final result = await readContract(getName, [], contract);
    setState(() {
      name = result.first;
    });
  }

  Future<void> getContractFunctions() async {
    contract =
        DeployedContract(ContractAbi.fromJson(abi, "Example"), contractAddress);

    /// Intialize contract functions
    getName = contract.function('getName');
    setName = contract.function('setName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ethereum Example"),
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
                    await writeContract(setName, [text.value.text], contract);
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
