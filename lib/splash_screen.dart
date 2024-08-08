import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'my_home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });

    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward().whenComplete(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(toggleDarkMode: (bool isDarkMode) {  },)),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('img/pic-splash.png'), // Your image path
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: _blurAnimation.value,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned.fill(
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Center(
                child: Transform.rotate(
                  angle: _controller.value * 2.0 * 3.14159, // Rotates 360 degrees
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('img/pic-ani.png'), // Replace with your animation image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
