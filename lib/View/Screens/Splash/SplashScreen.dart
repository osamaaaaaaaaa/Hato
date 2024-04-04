// ignore_for_file: prefer_const_constructors

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:superconnect/View/Screens/Home/MainContainer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: 'images/splash.png',
        nextScreen: MainContainer(),
        splashTransition: SplashTransition.rotationTransition,
      ),
    );
  }
}
