import 'package:afpemergencyapplication/LoginAndRegisterScreens/LogIn.dart';
import 'package:afpemergencyapplication/LoginAndRegisterScreens/UserProfile.dart';
import 'package:afpemergencyapplication/MainSreens/AmbulanceScreen.dart';
import 'package:afpemergencyapplication/MainSreens/FireFighterScreen.dart';
import 'package:afpemergencyapplication/MainSreens/PoliceScreen.dart';
import 'package:afpemergencyapplication/MainSreens/ThreeButtonsScreens.dart';
import 'package:afpemergencyapplication/RequestAndHistory/MainAlertTypeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmergencyType extends StatefulWidget {
  const EmergencyType({Key? key}) : super(key: key);
  static const routeName = '/emergencyHomeScreen';

  @override
  State<EmergencyType> createState() => _EmergencyTypeState();
}

class _EmergencyTypeState extends State<EmergencyType>
    with WidgetsBindingObserver {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    ThreeButtonsScreen(),
    AmbulanceScreen(),
    FireFighterScreen(),
    PoliceScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.addObserver(this);
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
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Emergency"),
        centerTitle: true,
        elevation: 0.0,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.green,
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              textTheme: const TextTheme().apply(bodyColor: Colors.green),
              dividerColor: Colors.purpleAccent,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            child: PopupMenuButton<int>(
              color: Colors.white,
              elevation: 5.0,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.add_alert,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "My Requests",
                        style: TextStyle(
                            color: Colors.purple, fontFamily: "GaramondBold"),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "My Profile",
                        style: TextStyle(
                            color: Colors.purple, fontFamily: "GaramondBold"),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout_outlined,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.purple, fontFamily: "GaramondBold"),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (item) => selectedItem(context, item),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _tabs[_currentIndex],

      //////////////////////////NAVIGATION////////////////////////////
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 13.0,
        unselectedFontSize: 10.0,
        backgroundColor: Colors.grey[100],
        selectedItemColor: Colors.green,
        elevation: 0.0,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 20,
              color: Colors.grey,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
              label: 'Ambulance',
              icon: Icon(
                Icons.car_repair,
                size: 20,
                color: Colors.green,
              )),
          const BottomNavigationBarItem(
              label: 'fighters',
              icon: Icon(
                Icons.local_fire_department,
                size: 20,
                color: Colors.orange,
              )),
          BottomNavigationBarItem(
            label: 'Police',
            icon: Icon(
              Icons.local_police,
              size: 20,
              color: Colors.blue[400],
            ),
          ),
        ],

        ///////////////////NAVIGATION ON-TAP//////////////////////
        onTap: ((int index) {
          setState(() {
            _currentIndex = index;
          });
        }),
      ),
    );
  }

  Future<void> selectedItem(BuildContext context, item) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;

    switch (item) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainAlertTypeScreen()),
        );
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
            context, UserProfile.routeName, (route) => false);
        break;
      case 2:
        await firebaseAuth.signOut();
        Navigator.pushNamedAndRemoveUntil(
            context, LogIn.routeName, (route) => false);
        break;
    }
  }
}
