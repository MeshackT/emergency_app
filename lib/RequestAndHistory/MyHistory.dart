import 'package:afpemergencyapplication/MainSreens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHistory extends StatefulWidget {
  MyHistory({Key? key}) : super(key: key);
  static const routeName = '/myRequestHistoryScreen';
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  _MyHistoryState createState() => _MyHistoryState();
}

class _MyHistoryState extends State<MyHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, EmergencyType.routeName, (route) => false);
          },
        ),
        title: const Text("My Request History"),
      ),
      body: const SizedBox(
        child: Center(
          child: Text('My request History'),
        ),
      ),
    );
  }
}
