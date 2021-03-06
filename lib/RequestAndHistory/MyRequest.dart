import 'package:afpemergencyapplication/CallerClass/DirectCallerClass.dart';
import 'package:afpemergencyapplication/EditRequests/EditRequest.dart';
import 'package:afpemergencyapplication/MainSreens/HomeScreen.dart';
import 'package:afpemergencyapplication/RequestAndHistory/MainAlertTypeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class MyRequest extends StatefulWidget {
  const MyRequest({Key? key}) : super(key: key);
  static const routeName = '/myRequestScreen';

  @override
  _MyRequestState createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  final Logger logger = Logger();
  final DirectCallerClass directCallerClass = DirectCallerClass();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> ambulanceRequestStream = FirebaseFirestore.instance
        .collection("ambulance-requests")
        //.orderBy('sendersName', descending: true)
        .where('owner', isEqualTo: user!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        title: const Text("My Ambulance Request"),
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
        stream: ambulanceRequestStream,
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
                  style: TextStyle(color: Colors.green, fontSize: 16),
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
                            style: TextStyle(fontSize: 14, color: Colors.grey),
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
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            data['fullName'][0],
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                        trailing: SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height + 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                data['time'],
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                                textAlign: TextAlign.end,
                              ),
                              const Divider(
                                height: 1,
                              ),
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
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('ambulance-requests')
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
                            Column(
                              children: [
                                const Text(
                                  "Await a call",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 14),
                                ),
                                Text(
                                  directCallerClass.formattedDate(data['date']),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const EditRequest(),
                                  ),
                                );
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
