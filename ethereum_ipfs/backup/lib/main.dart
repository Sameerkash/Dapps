import 'package:flutter/material.dart';
import 'example.dart';
import 'file_upload.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dapp(),
    );
  }
}

class Dapp extends StatefulWidget {
  const Dapp({Key? key}) : super(key: key);

  @override
  State<Dapp> createState() => _DappState();
}

class _DappState extends State<Dapp> {
  int currentIndex = 0;

  PageController _pageController = new PageController();

  void setIndex(index) {
    setState(() {
      _pageController.jumpToPage(index);
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          Example(),
          FileUpload(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: setIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Example"),
          BottomNavigationBarItem(
              icon: Icon(Icons.circle), label: "File Upload")
        ],
      ),
    );
  }
}
