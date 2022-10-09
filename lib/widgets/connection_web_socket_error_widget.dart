import 'package:flutter/material.dart';

class WebSocketConnectionErrorWidget extends StatelessWidget {
  const WebSocketConnectionErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 60.0, color: Colors.red),
          Expanded(
            child: Text("Verifique su conexion a la red DISOM-DETECT",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          )
        ],
      ),
    );
  }
}
