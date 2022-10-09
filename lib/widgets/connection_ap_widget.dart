import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pry_20220140/constants/global.dart';
import 'package:pry_20220140/database/database_helper.dart';
import 'package:pry_20220140/models/data_models/detection_data_model.dart';
import 'package:pry_20220140/widgets/connection_web_socket_error_widget.dart';
import 'package:tflite/tflite.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image/image.dart' as imglib;
import 'package:web_socket_channel/status.dart' as status;

class ConnectionAPWidget extends StatefulWidget {
  final Function? callback;
  const ConnectionAPWidget({Key? key, this.callback}) : super(key: key);

  @override
  State<ConnectionAPWidget> createState() => _ConnectionAPWidgetState();
}

class _ConnectionAPWidgetState extends State<ConnectionAPWidget> {
  final WebSocketChannel _channel =
      IOWebSocketChannel.connect('ws://192.168.4.1:8888');
  bool _isDetecting = false;
  late Future<void> _initModel;
  DateTime _initDatetime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initModel = loadTensorflowModel();
  }

  @override
  void dispose() {
    try {
      _channel.sink.close(status.goingAway);
    } catch (e) {}
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: _initModel,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Container(
              alignment: Alignment.center,
              child: Text("Error al cargar modelo"));
        }

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return StreamBuilder(
            stream: _channel.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return WebSocketConnectionErrorWidget();
              }

              if (snapshot.hasData) {
                process(snapshot.data as Uint8List);
                // return Container(
                //   child: Image.memory(
                //     snapshot.data,
                //     gaplessPlayback: true,
                //     width: 200.0,
                //     height: 200.0,
                //   ),
                // );
                if (DateTime.now().difference(_initDatetime).inMilliseconds <=
                    2000) {
                  return Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi, size: 60.0),
                        Text("Conexión Exitosa",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0))
                      ],
                    ),
                  );
                }

                return Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 60.0),
                      Text("Conduciendo",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0))
                    ],
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }

  Future<bool> process(Uint8List imageRaw) async {
    if (_isDetecting) {
      return false;
    }

    _isDetecting = true;

    // Tflite.runModelOnFrame(
    //         bytesList: [_preprocessImage(imageRaw)],
    //         imageHeight: 64,
    //         imageWidth: 64)
    try {
      Tflite.runModelOnBinary(binary: _preprocessImage(imageRaw))
          .then((response) async {
        print(response);

        try {
          var inference =
              response?.where((element) => element["confidence"] >= 0.8).first;

          await insertToDatabase(inference);

          if (inference["label"] != Global.SAFE_DRIVING) {
            await Future.value(this.widget.callback!());
          }
        } catch (e) {
          print("Error en inserción a base de datos: " + e.toString());
        }

        _isDetecting = false;
      });
    } catch (e) {
      print("Error al procesar modelo: " + e.toString());
    }

    return true;
  }

  Future<String> loadTensorflowModel() async {
    Tflite.close();
    String? res = await Tflite.loadModel(
        model: "assets/tensorflow_models/tflite_model.tflite",
        labels: "assets/tensorflow_models/label-classs.txt");

    // await Tflite.close();

    return res!;
  }

  Future<bool> insertToDatabase(inference) async {
    try {
      DatabaseHelper.instance.insert(
          DetectionDataModel(inference["confidence"], inference["label"]));
    } catch (e) {
      print("Error al insertar en db: " + e.toString());
      return false;
    }
    return true;
  }

  Uint8List _preprocessImage(Uint8List rawImage) {
    late imglib.Image? image;
    try {
      image = imglib.decodeJpg(rawImage);
      image = imglib.copyResize(image!, width: 64, height: 64);
      return _imageToByteListFloat32(image, 64, 127.5, 127.5);
    } catch (e) {
      print("Error al procesar imagen:" + e.toString());
    }
    return image!.getBytes();
  }

  Uint8List _imageToByteListFloat32(
      imglib.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}
