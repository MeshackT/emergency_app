import 'package:afpemergencyapplication/RequestAndHistory/PoliceRequest.dart';
import 'package:afpemergencyapplication/models/GetLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class EditPoliceRequest extends StatefulWidget {
  const EditPoliceRequest({Key? key}) : super(key: key);
  static const route = '/editPoliceRequest';

  @override
  _EditPoliceRequestState createState() => _EditPoliceRequestState();
}

class _EditPoliceRequestState extends State<EditPoliceRequest>
    with WidgetsBindingObserver {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey2 = GlobalKey<FormState>();
  GetLocation getLocation = GetLocation();
  Logger log = Logger(printer: PrettyPrinter(colors: true));

  // String uid = "";
  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController emergencyTypeRequest = TextEditingController();

  Position? _currentPosition;
  String latitudeData = "";
  String longitudeData = "";

  _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .whenComplete(() => Fluttertoast.showToast(msg: "Location captured"));
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not capture your location");
    }
    setState(() {
      latitudeData = (_currentPosition!.latitude).toString();
      longitudeData = (_currentPosition!.longitude.toString());
      address.text = latitudeData + " " + longitudeData;
    });
  }

  bool validationAndSave() {
    final form = _formKey2.currentState;
    if (form!.validate()) {
      form.save();
      return false;
    }
    return true;
  }

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
    Stream<QuerySnapshot> policeRequestStream =
        FirebaseFirestore.instance.collection("police-requests").snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, PoliceRequest.routeName, (route) => false);
          },
        ),
        backgroundColor: Colors.green,
        title: const Text('Edit My Police Request'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: policeRequestStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //TO DO
          if (snapshot.hasError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('Something went wrong'),
                SizedBox(
                  height: 10.0,
                ),
                CircularProgressIndicator(),
              ],
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    strokeWidth: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Loading information'),
                ],
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
                child: Card(
                  elevation: 8,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Form(
                      key: _formKey2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: TextFormField(
                              controller: emergencyTypeRequest,
                              onSaved: (value) {
                                setState(() {
                                  emergencyTypeRequest.text = value!;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Enter emergency type");
                                }
                                return null;
                              },
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.purple),
                              decoration: const InputDecoration(
                                label: Text(
                                  'Emergency Type',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.purple),
                                ),
                                hintText: 'Enter Emergency Type',
                                prefix: Icon(
                                  Icons.help,
                                  color: Colors.grey,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5, top: 5),
                            child: TextFormField(
                              controller: email,
                              onSaved: (value) {
                                setState(() {
                                  email.text = value!;
                                  if (kDebugMode) {
                                    print("email: $email");
                                  }
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Enter email");
                                }
                                if (!value.contains("@")) {
                                  return ("Please Enter a valid email");
                                }
                                return null;
                              },
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.purple),
                              decoration: const InputDecoration(
                                prefix: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                                label: Text(
                                  'Email',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.purple),
                                ),
                                hintText: 'email@gmail.com',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: TextFormField(
// obscureText: true,
                              controller: fullName,
                              onSaved: (value) {
//Do something with the user input.
                                setState(() {
                                  fullName.text = value!;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Enter your name.");
                                }
                                return null;
                              },
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.purple),
                              decoration: const InputDecoration(
                                label: Text(
                                  'Full Names',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.purple),
                                ),
                                hintText: 'Full Names',
                                prefix: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: TextFormField(
                              controller: phoneNumber,
                              onSaved: (value) {
                                setState(() {
                                  phoneNumber.text = value!;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("10 digit number is required");
                                }
                                if (value.length < 10) {
                                  return ("Enter a valid phone number with 10 digits");
                                } else if (value.length > 10) {
                                  return ("Too many digits entered");
                                }
                              },
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.purple),
                              decoration: const InputDecoration(
                                label: Text(
                                  'Phone Number',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.purple),
                                ),
                                hintText: 'Phone Number',
                                prefix: Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: TextFormField(
                              controller: address,
                              onSaved: (value) {
                                //Do something with the user input.
                                setState(() {
                                  address.text = value!;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Enter your address.");
                                }
                                return null;
                              },
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.purple),
                              decoration: InputDecoration(
                                label: const Text('Address'),
                                hintText: 'Address',
                                suffix: IconButton(
                                  onPressed: () async {
                                    _getCurrentLocation();
                                    setState(() {
                                      address.text =
                                          latitudeData + " " + longitudeData;
                                    });
                                  },
                                  icon: const Icon(Icons.my_location),
                                  color: Colors.green,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextButton(
                            onPressed: () async {
                              Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(),
                                  Text("Loading data"),
                                ],
                              ));
                              try {
                                await firebaseFirestore
                                    .collection('police-requests')
                                    .doc(document.id)
                                    .get()
                                    .then(
                                  (value) {
                                    setState(
                                      () {
                                        // String uid = "";
                                        fullName.text = data['fullName'];
                                        email.text = data['email'];
                                        phoneNumber.text = data['phoneNumber'];
                                        address.text = data['address'];
                                        emergencyTypeRequest.text =
                                            data['emergencyTypeRequest'];
                                      },
                                    );
                                  },
                                );
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg: '$e',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 16);
                              }
                            },
                            child: const Text(
                              "Get information",
                              style: TextStyle(color: Colors.purple),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(15)),
                                  // foregroundColor:
                                  //     MaterialStateProperty.all<Color>(Colors.green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                          side: const BorderSide(
                                              color: Colors.green)))),
                              onPressed: () async {
                                //Send this information to the database
                                Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(),
                                    Text(""),
                                  ],
                                ));
                                validationAndSave();
                                if (emergencyTypeRequest.text.isEmpty) {
                                  return;
                                } else if (emergencyTypeRequest.text
                                    .trim()
                                    .isNotEmpty) {
                                  try {
                                    //writing to firebase
                                    //adding the details to the constructor
                                    return await firebaseFirestore
                                        .collection("police-requests")
                                        .doc(document.id)
                                        .update({
                                      'fullName': fullName.text.trim(),
                                      'email': email.text.trim(),
                                      'phoneNumber': phoneNumber.text.trim(),
                                      'address': address.text.trim(),
                                      'emergencyTypeRequest':
                                          emergencyTypeRequest.text.trim(),
                                    }).whenComplete(
                                      () => Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          PoliceRequest.routeName,
                                          (route) => false),
                                    ); //writing to firebase

                                  } catch (e) {
                                    setState(() {
                                      const CircularProgressIndicator();
                                    });
                                    Fluttertoast.showToast(
                                        msg: '$e',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        fontSize: 16);
                                  }
                                }
                              },
                              child: const Text(
                                "Update",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
