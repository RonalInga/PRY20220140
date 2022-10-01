import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pry_20220140/constants/global.dart';
import 'package:pry_20220140/database/database_helper.dart';
import 'package:pry_20220140/models/data_models/detection_data_model.dart';
import 'package:tflite/tflite.dart';

class CameraWidget extends StatefulWidget {
  final Function? callback;
  const CameraWidget({Key? key, this.callback}) : super(key: key);

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController cameraController;
  late Future<void> initCamera;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    initCamera = initCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: initCamera,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(child: Text("Error al cargar cámara"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Container(child: CameraPreview(cameraController));
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  @override
  void dispose() {
    cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  Future<void> initCameraController() async {
    try {
      var modelLoaded = await loadTensorflowModel();
      print(modelLoaded);

      var frontCamera = await getFrontCamera();
      cameraController = CameraController(frontCamera, ResolutionPreset.low);
      await cameraController.initialize();

      if (!mounted) {
        return;
      }

      setState(() {});

      cameraController.startImageStream((image) async {
        if (isDetecting) {
          return;
        }

        isDetecting = true;

        Tflite.runModelOnFrame(
                bytesList: image.planes.map((plane) => plane.bytes).toList(),
                imageHeight: 64,
                imageWidth: 64)
            .then((response) async {
          print(response);

          try {
            var inference = response
                ?.where((element) => element["confidence"] >= 0.8)
                .first;

            await insertToDatabase(inference);

            if (inference["label"] != Global.SAFE_DRIVING) {
              await Future.value(this.widget.callback!());
            }
          } catch (e) {}

          isDetecting = false;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<CameraDescription> getFrontCamera() async {
    return await availableCameras().then((cameras) => cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front));
  }

  Future<String> loadTensorflowModel() async {
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
}
