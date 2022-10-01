import 'package:flutter/material.dart';
import 'package:pry_20220140/screens/calendar_screen.dart';
import 'package:pry_20220140/screens/ip_address_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset("assets/images/logo_size.jpg", scale: 0.9),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Menú",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.car_rental,
                        size: 60.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IpAddressScreen(),
                                    maintainState: false));
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
                            'Iniciar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.analytics,
                        size: 60.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CalendarScreen()));
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
                            'Reportes',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.camera,
                        size: 60.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IpAddressScreen()));
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
                            'Configuración',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
