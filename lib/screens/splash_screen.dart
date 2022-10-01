import 'dart:async';

import 'package:flutter/material.dart';

import 'main_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  void initConfig(BuildContext context) {
    Timer(const Duration(seconds: 5), () => _afterTimeRun(context));
  }
  

  @override
  Widget build(BuildContext context) {
    initConfig(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Image.asset("assets/images/logo_size.jpg", scale: 0.5,),
      ),
    );
  }

  void _afterTimeRun(BuildContext context) async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
  }
}