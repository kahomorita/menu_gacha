import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'main.dart';

class DiscardItemWidget extends StatefulWidget {
  @override
  _DragonPageState createState() => _DragonPageState();
}

class _DragonPageState extends State<DiscardItemWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/dragon-fire02.json',
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward().whenComplete(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
