import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';
import 'menu.dart';

class Cart extends StatefulWidget {
  final int? num;
  final int? quantity;

  /// key1: menu番号(0〜2)　key2: 人数(1〜5)
  const Cart({Key? key, this.num, this.quantity}) : super(key: key);

  @override
  _Cart createState() => _Cart();
}

class _Cart extends State<Cart> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Menu _menu = Menu(name: "", itemList: []);
  int _total = 0;

  @override
  void initState() {
    super.initState();
    setMenu(widget.num, widget.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _appBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: _menu.itemList.length == 0
                ? EmptyCart()
                : AnimatedList(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    key: _listKey,
                    initialItemCount: _menu.itemList.length,
                    itemBuilder: (BuildContext context, int index,
                        Animation<double> animation) {
                      return _buildItem(_menu.itemList[index], animation);
                    },
                  ),
          ),
          bottomBarTitle(),
          bottomBarButton()
        ],
      ),
    );
  }

  Future<void> setMenu(int? num, int? quantity) async {
    num = num == null ? 0 : num;
    String data = await loadJsonAsset(num);
    _menu = convertJsonToMenu(data, quantity);
    _total = await sumMenu();
    setState(() {});
  }

  Menu convertJsonToMenu(String value, int? quantity) {
    quantity = quantity == null ? 1 : quantity;
    Map<String, dynamic> map = jsonDecode(value);
    Menu menu = Menu(name: map["name"], itemList: []);
    List<dynamic> list = map["itemList"];
    list.forEach((e) => {
          menu.itemList.add(Item(
              name: e["name"],
              price: e["price"],
              quantity: quantity!,
              images: e["images"]))
        });
    return menu;
  }

  Future<int> sumMenu() async {
    List<int> sum = [];
    _menu.itemList.forEach((e) {
      sum.add(e.price * e.quantity);
    });
    return sum.reduce((a, b) => a + b);
  }

  Future<String> loadJsonAsset(int num) async {
    const menuNameList = [
      "curry-rice.json",
      "taco-rice.json",
      "cream-shoe.json"
    ];
    String data =
        await rootBundle.loadString('assets/json/' + menuNameList[num]);
    return data;
  }

  void _incrementCounter(Item item) {
    setState(() {
      int count = item.quantity;
      if (count < 5) {
        item.quantity++;
        _update();
      }
    });
  }

  void _decrementCounter(Item item) {
    setState(() {
      int count = item.quantity;
      if (count > 1) {
        item.quantity--;
        _update();
      }
    });
  }

  void _update() {
    _total = 0;
    _menu.itemList.forEach((e) => _total += e.price * e.quantity);
  }

  void _deleteItem(Item item) {
    int removeIndex = _menu.itemList.indexOf(item);
    Item removedItem = _menu.itemList.removeAt(removeIndex);

    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem, animation);
    };

    _listKey.currentState?.removeItem(removeIndex, builder);
    setState(() {
      _update();
    });
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
        title: Text(
          _menu.name,
          style: Theme.of(context).textTheme.headline4,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[100],
        elevation: 0);
  }

  Widget _buildItem(Item item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(13),
            height: 120,
            decoration: BoxDecoration(
                color: Colors.grey[300]?.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/" + item.images,
                      width: 80,
                      height: 130,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Text(
                          item.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          (item.price.toString() + "円"),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      IconButton(
                        splashRadius: 10.0,
                        onPressed: () {
                          _decrementCounter(item);
                        },
                        icon: const Icon(
                          Icons.remove,
                          color: Color(0xFFEC6813),
                        ),
                      ),
                      Text(
                        item.quantity.toString() + "人前",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        splashRadius: 10.0,
                        onPressed: () {
                          _incrementCounter(item);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xFFEC6813),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            right: 7,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black87,
              child: IconButton(
                icon: Icon(Icons.close),
                iconSize: 16,
                splashRadius: 23,
                onPressed: () {
                  _deleteItem(item);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomBarTitle() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("合計",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                _total.toString() + "円",
                key: ValueKey<int>(_total),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFEC6813),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getShow() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Text("注文を確定しますか？"),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('いいえ'),
              onPressed: () {
                Navigator.of(context).pop();
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
                    builder: (context) => MyHomePage(flag: true),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  Widget bottomBarButton() {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
          child: ElevatedButton(
            child: const Text("注文"),
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
              getShow();
            },
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/empty-cart.png',
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 30),
        const Text(
          "カートが空です。",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )
      ],
    );
  }
}
