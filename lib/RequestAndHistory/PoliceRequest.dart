import 'package:afpemergencyapplication/EditRequests/EditPoliceRequest.dart';
import 'package:afpemergencyapplication/MainSreens/HomeScreen.dart';
import 'package:afpemergencyapplication/RequestAndHistory/MainAlertTypeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class PoliceRequest extends StatefulWidget {
  static const routeName = '/PoliceRequest';

  const PoliceRequest({Key? key}) : super(key: key);

  @override
  _PoliceRequestState createState() => _PoliceRequestState();
}

class _PoliceRequestState extends State<PoliceRequest>
    with WidgetsBindingObserver {
  Logger logger = Logger();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String uid = "";

  @override
  void initState() {
    super.initState();
    // _uploadUserData();
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
    Stream<QuerySnapshot> policeRequestStream = FirebaseFirestore.instance
        .collection("police-requests")
        .where('owner', isEqualTo: user!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        title: const Text("My Police Request"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainAlertTypeScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.house),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmergencyType(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: policeRequestStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //TO DO
          if (snapshot.hasError) {
            return Stack(
              children: const [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Text(
                  'Something went wrong',
                  style: TextStyle(color: Colors.purple, fontSize: 16),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Loading information',
                    style: TextStyle(color: Colors.purple, fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (snapshot.data!.size == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "No data found",
                    style: TextStyle(color: Colors.purple, fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create a request to see you My Request",
                    style: TextStyle(color: Colors.purple, fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData == true) {
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];

                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          data['fullName'],
                          style: const TextStyle(color: Colors.green),
                        ),
                        subtitle: ExpansionTile(
                          title: const Text(
                            "More",
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                          children: [
                            const Text(
                              "EM Type: ",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              data['emergencyTypeRequest'],
                              style: const TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                            const Text("Phone Number"),
                            Text(
                              data["phoneNumber"],
                              style: const TextStyle(
                                letterSpacing: 3,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        // Text(
                        //   data['emergencyTypeRequest'],
                        //   style: const TextStyle(color: Colors.red),
                        // ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Text(
                            data['fullName'][0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        trailing: SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height + 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Address",
                                style: TextStyle(color: Colors.green),
                              ),
                              Text(
                                data['address'],
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 10),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () async {
                                setState(() {
                                  const CircularProgressIndicator();
                                });
                                try {
                                  FirebaseFirestore.instance
                                      .collection('police-requests')
                                      .doc(data.id)
                                      .delete()
                                      .then(
                                        (value) => logger.i(data.id),
                                      );
                                  Fluttertoast.showToast(
                                      msg: 'Request Deleted',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.grey,
                                      fontSize: 16.0);
                                } catch (error) {
                                  logger.i("failed $error ");
                                  Fluttertoast.showToast(
                                      msg: 'Request failed to Deleted $error',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.grey,
                                      fontSize: 16.0);
                                }
                              },
                            ),
                            const Text(
                              "Await a call",
                              style:
                                  TextStyle(color: Colors.purple, fontSize: 14),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    EditPoliceRequest.route, (route) => false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Text("No data is Found");
        },
      ),
    );
  }
}
