import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'dragon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _quantity = 1;
  void _incrementCounter() {
    setState(() {
      if (_quantity < 5) {
        _quantity++;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  getShow() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Text("カレーライスの注文を確定しますか？"),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('いいえ'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiscardItemWidget(),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text(
                'はい',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  Future<void> stopSevenSeconds() async {
    await Future.delayed(Duration(seconds: 7));
    getShow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("本日発送は15時まで"),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  splashRadius: 10.0,
                  onPressed: () {
                    _decrementCounter();
                  },
                  icon: const Icon(
                    Icons.remove,
                    color: Color(0xFFEC6813),
                  ),
                ),
                Text(
                  _quantity.toString() + "人前",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  splashRadius: 10.0,
                  onPressed: () {
                    _incrementCounter();
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xFFEC6813),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Lottie.asset('assets/gachadora05.json', repeat: false);
                },
              );
              stopSevenSeconds();
            },
            // 対象の画像を記述
            child: Image.asset('assets/button_start1.png'),
          )
        ],
      ),
    );
  }
}
