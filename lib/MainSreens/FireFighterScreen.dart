import 'package:afpemergencyapplication/RequestAndHistory/FireFighterRequest.dart';
import 'package:afpemergencyapplication/models/GetLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class FireFighterScreen extends StatefulWidget {
  const FireFighterScreen({Key? key}) : super(key: key);
  static const routeName = '/firefighterScreen';

  @override
  _FireFighterScreenState createState() => _FireFighterScreenState();
}

class _FireFighterScreenState extends State<FireFighterScreen>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey();
  GetLocation getLocation = GetLocation();
  Logger log = Logger(printer: PrettyPrinter(colors: true));

  User? user = FirebaseAuth.instance.currentUser;

  String uid = "";
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
      address.text = "$latitudeData $longitudeData";
    });
  }

  @override
  void initState() {
    super.initState();
    // _uploadUserData();
    _getUserData();
  }

  bool showProgressBar = false;
  bool progressBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5, top: 0.0),
                    child: const Center(
                      child: Text(
                        "Confirm your Details",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 2.0,
                    shadowColor: Colors.green,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              child: TextFormField(
                                controller: emergencyTypeRequest,
                                onSaved: (value) {
                                  setState(() {
                                    emergencyTypeRequest.text = value!;
                                  });
                                },
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.green),
                                decoration: const InputDecoration(
                                  label: Text(
                                    'Emergency Type',
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.green),
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
                              margin:
                                  const EdgeInsets.only(bottom: 10, top: 10),
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
                                    fontSize: 14.0, color: Colors.green),
                                decoration: const InputDecoration(
                                  prefix: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  label: Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.green),
                                  ),
                                  hintText: 'email@gmail.com',
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
                                // obscureText: true,
                                controller: fullName,
                                onSaved: (value) {
                                  //Do something with the user input.
                                  setState(() {
                                    fullName.text = value!;
                                  });
                                },
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.green),
                                decoration: const InputDecoration(
                                  label: Text(
                                    'Full Names',
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.green),
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
                            SizedBox(
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
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.green),
                                decoration: const InputDecoration(
                                  label: Text(
                                    'Phone Number',
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.green),
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
                                // obscureText: true,
                                controller: address,
                                onSaved: (value) {
                                  //Do something with the user input.
                                  setState(() {
                                    address.text = value!;
                                  });
                                },
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.green),
                                decoration: InputDecoration(
                                  label: const Text(
                                    'Address',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  hintText: 'Address',
                                  suffix: IconButton(
                                    onPressed: () async {
                                      _getCurrentLocation();
                                      setState(() {
                                        address.text =
                                            "$latitudeData $longitudeData";
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(15)),
                        // foregroundColor:
                        //     MaterialStateProperty.all<Color>(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                            side: const BorderSide(
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (emergencyTypeRequest.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Insert emergencyType");
                        } else {
                          sendRequest();
                        }
                      },
                      child: const Text(
                        "Request",
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
      ),
    );
  }

  ///////////////////////////////////////////
  //            fetch user data            //
  //////////////////////////////////////////
  Future<void> _getUserData() async {
    //instantiate the classes
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    await firebaseFirestore
        .collection('users')
        // .document((await FirebaseAuth.instance.currentUser()).uid)
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        const CircularProgressIndicator();
        fullName.text = value.data()!['fullName'].toString();
        email.text = value.data()!['email'].toString();
        phoneNumber.text = value.data()!['phoneNumber'].toString();
        address.text = value.data()!['address'].toString();
      });
    });
  }

  //////////////////////////////////////////
//     put data in the database         //
// ///////////////////////////////////////
  Future<void> sendRequest() {
    CollectionReference users =
        FirebaseFirestore.instance.collection('fire-fighter-request');
    //date
    Timestamp timeStamp = Timestamp.now();
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    //time
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hm().format(now);

    const CircularProgressIndicator();
    return users
        .add({
          'uid': uid,
          'date': dateTime,
          'time': formattedTime,
          'email': email.text,
          'phoneNumber': phoneNumber.text,
          'emergencyTypeRequest': emergencyTypeRequest.text,
          'fullName': fullName.text,
          'address': address.text,
          'owner': user?.uid,
        })
        .then(
          (value) => Fluttertoast.showToast(msg: "Successfully requested")
              .whenComplete(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FireFighterRequest(),
              ),
            ),
          ),
        )
        .catchError(
          (error) =>
              Fluttertoast.showToast(msg: "failed to send details $error"),
        );
  }
}
