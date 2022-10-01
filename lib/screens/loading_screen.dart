import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pry_20220140/screens/start_driving_screen.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  void initConfig(BuildContext context) {
    Timer(
        const Duration(seconds: 2),
        () => {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => StartDrivingScreen()))
            });
  }

  @override
  Widget build(BuildContext context) {
    initConfig(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi, size: 60.0),
            Text("Conexión Exitosa",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))
          ],
        ),
      ),
    );
  }
}
