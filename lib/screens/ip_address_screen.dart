import 'package:flutter/material.dart';

import 'loading_screen.dart';

class IpAddressScreen extends StatelessWidget {
  const IpAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/logo_size.jpg", scale: 0.8),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera,
                            size: 60.0,
                          ),
                          Text(
                            "Ingresar IP",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          )
                        ],
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: 'Ej: 172.32.25.12',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoadingScreen()));
                      },
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(4.0),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.redAccent),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 44)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black)),
                      child: Text(
                        'Conectar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
