import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:volume_control/volume_control.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final _player = new AudioPlayer();

  @override
  void initState() {
    super.initState();
    setAudio();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> setAudio() async {
    VolumeControl.setVolume(1.0);
    const alarmAudioPath = "audios/samsung_alarma.mp3";
    final url = await new AudioCache().load(alarmAudioPath);
    _player.play(url.path, isLocal: true, stayAwake: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.redAccent,
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 60.0,
                    ),
                    Text(
                      "Peligro al conducir",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ],
                )),
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
                            MaterialStateProperty.all(Colors.black)),
                    child: Text(
                      'Culminar conducción',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
