import 'dart:async';

import 'package:afpemergencyapplication/EditRequests/EditFireFighterRequest.dart';
import 'package:afpemergencyapplication/EditRequests/EditPoliceRequest.dart';
import 'package:afpemergencyapplication/EditRequests/EditRequest.dart';
import 'package:afpemergencyapplication/LoginAndRegisterScreens/LogIn.dart';
import 'package:afpemergencyapplication/LoginAndRegisterScreens/PasswordReset.dart';
import 'package:afpemergencyapplication/LoginAndRegisterScreens/UserProfile.dart';
import 'package:afpemergencyapplication/LoginAndRegisterScreens/UserRegister.dart';
import 'package:afpemergencyapplication/LoginAndRegisterScreens/updateProfile.dart';
import 'package:afpemergencyapplication/MainSreens/AmbulanceScreen.dart';
import 'package:afpemergencyapplication/MainSreens/FireFighterScreen.dart';
import 'package:afpemergencyapplication/MainSreens/HomeScreen.dart';
import 'package:afpemergencyapplication/MainSreens/PoliceScreen.dart';
import 'package:afpemergencyapplication/MainSreens/ThreeButtonsScreens.dart';
import 'package:afpemergencyapplication/RequestAndHistory/FireFighterRequest.dart';
import 'package:afpemergencyapplication/RequestAndHistory/MainAlertTypeScreen.dart';
import 'package:afpemergencyapplication/RequestAndHistory/MyHistory.dart';
import 'package:afpemergencyapplication/RequestAndHistory/MyRequest.dart';
import 'package:afpemergencyapplication/RequestAndHistory/PoliceRequest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Logger logger = Logger();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const EmergencyType(),
          ),
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, LogIn.routeName, (route) => false);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.addObserver(this);
    super.dispose();
  }

/////////////////////////////////////////////////////////////////////
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
    return MaterialApp(
      title: "AFP",
      theme: ThemeData(
        primaryColor: Colors.green,
        primaryColorDark: Colors.purple[700],
        fontFamily: 'GaramondBold',
        appBarTheme: const AppBarTheme(color: Colors.green),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        ////user login and register
        LogIn.routeName: (ctx) => const LogIn(),
        UserRegister.routeName: (ctx) => const UserRegister(),
        ////Emergency Call buttons
        EmergencyType.routeName: (ctx) => const EmergencyType(),
        ////update profile
        UpdateProfile.routeName: (ctx) => const UpdateProfile(),
        UserProfile.routeName: (ctx) => const UserProfile(),
        ////Navigation screens
        AmbulanceScreen.routeName: (ctx) => const AmbulanceScreen(),
        FireFighterScreen.routeName: (ctx) => const FireFighterScreen(),
        PoliceScreen.routeName: (ctx) => const PoliceScreen(),
        ThreeButtonsScreen.routeName: (ctx) => const ThreeButtonsScreen(),
        ////reset password
        PasswordReset.routeName: (ctx) => const PasswordReset(),
        ////my request screen
        MyHistory.routeName: (ctx) => MyHistory(),
        //edit your Requests
        EditRequest.routeName: (ctx) => const EditRequest(),
        EditPoliceRequest.route: (ctx) => const EditPoliceRequest(),
        EditFireFighterRequest.routeName: (ctx) =>
            const EditFireFighterRequest(),
        // EditPoliceRequest.routename: (ctx) => const EditPoliceRequest(),
        //my alert button screens
        MyRequest.routeName: (ctx) => const MyRequest(),
        MainAlertTypeScreen.routeName: (ctx) => const MainAlertTypeScreen(),
        FireFighterRequest.routeName: (ctx) => const FireFighterRequest(),
        PoliceRequest.routeName: (ctx) => const PoliceRequest(),
      },
      // home: EmergencyType(),
//// check if user is signed (Open Chat page ) if user is not signed in (open welcome page)
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? EmergencyType.routeName
          : LogIn.routeName,
    );
  }
}
