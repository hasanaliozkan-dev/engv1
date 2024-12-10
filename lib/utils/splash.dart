import 'package:flutter/material.dart';
import 'package:engv1/sign_in.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {

  @override
  void initState() {
    super.initState();
    navigateToSignIn();
  }
  void navigateToSignIn() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInPage()));

  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      //put logo here
      splash: Center(
            child: Image.asset(
              'assets/logo.png',
              width: 200,
              height: 200,)
            ),

      nextScreen: const SignInPage(),
      splashTransition: SplashTransition.scaleTransition,

    );
  }
}