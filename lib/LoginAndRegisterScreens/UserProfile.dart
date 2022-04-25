import 'dart:ui';

import 'package:afpemergencyapplication/LoginAndRegisterScreens/LogIn.dart';
import 'package:afpemergencyapplication/LoginAndRegisterScreens/updateProfile.dart';
import 'package:afpemergencyapplication/MainSreens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/UserModel.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);
  static const routeName = '/UserProfile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with WidgetsBindingObserver {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
  dynamic list = [];

  bool showProgressBar = false;

  String uid = "";
  String email = "";
  String phoneNumber = "";
  String fullName = "";
  String address = "";

  @override
  void initState() {
    super.initState();
    // _uploadUserData();
    _fetch();
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
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacementNamed(context, EmergencyType.routeName);
          },
        ),
        backgroundColor: Colors.green,
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, UpdateProfile.routeName);
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Container(
              //////
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 70,
                    margin: const EdgeInsets.only(
                      bottom: 7,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.my_location,
                        size: 70,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "My Profile",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  /////////////////////////////////////////////////////////////////////////
                  /////////////////////////////////////////////////////////////////////////
                  ////////////////////////////////////////////////////////////////////////

                  SizedBox(
                    height: 290,
                    child: Card(
                      elevation: 2.0,
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Center(
                              child: Text(
                                "Information",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 250,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Names :",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Email :",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Phone Number :",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Address :",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 250,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          fullName,
                                          style: const TextStyle(
                                              color: Colors.purple),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          email,
                                          style: const TextStyle(
                                              color: Colors.purple),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          phoneNumber,
                                          style: const TextStyle(
                                              color: Colors.purple),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          address,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              color: Colors.purple),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  /////////////////////////////////////////////////////////////////////////
                  /////////////////////////////////////////////////////////////////////////
                  ////////////////////////////////////////////////////////////////////////
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        await firebaseAuth.signOut();
                        Navigator.pushReplacementNamed(
                            context, LogIn.routeName);
                      },
                      child: const Text(
                        "Sign out",
                        style: TextStyle(
                            fontFamily: 'Mplus', color: Colors.purple),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LogIn()));
  }

  _fetch() async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((value) {
        setState(() {
          fullName = value.data()!['fullName'].toString();
          email = value.data()!['email'].toString();
          phoneNumber = value.data()!['phoneNumber'].toString();
          address = value.data()!['address'].toString();
        });
      });
    }
  }
}
///////////////////////////////////////////////////////////////
