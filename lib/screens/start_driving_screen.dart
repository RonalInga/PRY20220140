import 'package:flutter/material.dart';
import 'package:pry_20220140/widgets/camera_widget.dart';
import 'package:pry_20220140/widgets/connection_ap_widget.dart';

import 'alert_screen.dart';

class StartDrivingScreen extends StatelessWidget {
  const StartDrivingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: ConnectionAPWidget(
                callback: () async => await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => AlertScreen(),
                        maintainState: false)),
              ),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Icon(
              //       Icons.gps_fixed,
              //       size: 60.0,
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text(
              //         "Conducción en curso",
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold, fontSize: 15.0),
              //       ),
              //     )
              //   ],
              // ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(4.0),
                        shadowColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: MaterialStateProperty.all(
                            Size(double.infinity, 44)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.redAccent)),
                    child: Text(
                      'Culminar conducción',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
