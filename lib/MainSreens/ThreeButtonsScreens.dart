import 'package:afpemergencyapplication/CallerClass/DirectCallerClass.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ThreeButtonsScreen extends StatefulWidget {
  const ThreeButtonsScreen({Key? key}) : super(key: key);
  static const routeName = '/threeButtonsScreen';

  @override
  _ThreeButtonsScreenState createState() => _ThreeButtonsScreenState();
}

class _ThreeButtonsScreenState extends State<ThreeButtonsScreen>
    with WidgetsBindingObserver {
  DirectCallerClass directCallerClass = DirectCallerClass();
  Logger log = Logger(
    printer: PrettyPrinter(colors: true),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.addObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    WidgetsBinding.instance!.addObserver(this);
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
              child: Center(
                child: Text(
                  "Tap-To-Call",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //////////////////////Ambulance/////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: InkWell(
                        onTap: () async {
                          await directCallerClass.callNumber();
                        },
                        child: const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.car_repair,
                            color: Colors.green,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //////////////////////Fire/////////////////////////////////////

                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: InkWell(
                        onTap: () {
                          directCallerClass.callFireFighterNumber();
                        },
                        child: const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.local_fire_department,
                            color: Colors.red,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //////////////////////Police/////////////////////////////////////

                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: InkWell(
                        onTap: () async {
                          await directCallerClass.callPoliceNumber();
                        },
                        child: const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.local_police,
                            color: Colors.blue,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
