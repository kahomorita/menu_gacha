import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(flag: false),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final bool flag;
  MyHomePage({Key? key, required this.flag}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> menuList = ["カレーライス", "タコライス", "クリームシチュー"];
  int _quantity = 1;
  int _num = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (widget.flag)
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 10),
                    child: Text("注文を完了しました。"),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('はい'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
    });
  }

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

  void _randomSet() {
    setState(() {
      _num = Random().nextInt(3);
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
              child: Text(menuList[_num] + "の注文を確定しますか？"),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('いいえ'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return Lottie.asset('assets/dragon-fire02.json',
                        repeat: false);
                  },
                );
                stopSevenSeconds2();
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
                    builder: (context) => Cart(num: _num, quantity: _quantity),
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
    _randomSet();
    getShow();
  }

  Future<void> stopSevenSeconds2() async {
    await Future.delayed(Duration(seconds: 7));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("本日発送は15時まで"),
        backgroundColor: Color.fromRGBO(0xE6, 0x13, 0x10, 1.0),
        automaticallyImplyLeading: false,
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
