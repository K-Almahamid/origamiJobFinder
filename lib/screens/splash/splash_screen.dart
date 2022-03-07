import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origami/screens/feed/feed_screen.dart';
import 'package:origami/screens/home/home_screen.dart';
import 'package:origami/shared/components/constants.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {

   const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
          child: HomeScreen(),
          type: PageTransitionType.bottomToTop,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: xSilver,
      body: Center(
        child: Lottie.asset('assets/animations/splash.json',repeat: false)
      ),
    );
  }
}
