import 'package:afpemergencyapplication/LoginAndRegisterScreens/LogIn.dart';
import 'package:afpemergencyapplication/MainSreens/HomeScreen.dart';
import 'package:afpemergencyapplication/models/GetLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../models/UserModel.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({Key? key}) : super(key: key);
  static const routeName = '/registerUser';

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  Logger log = Logger(printer: PrettyPrinter(colors: true));

  // AuthenticationClass authenticationClass = AuthenticationClass();
  GetLocation getLocation = GetLocation();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController address = TextEditingController();

  bool passwordVisible = true;

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
    final form = _formKey.currentState;
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
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Icon(
                        Icons.my_location,
                        size: 60,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Divider(
                    height: 8.0,
                    color: Colors.green[100],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5, top: 5),
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.purple, fontSize: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
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
                                  hintText: 'email',
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
                                obscureText: passwordVisible,
                                controller: password,
                                onSaved: (value) {
                                  setState(() {
                                    password.text = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("Enter a password");
                                  }
                                  if (value.length < 5) {
                                    return ("Your password is too short!(Length 7 minimum)");
                                  }
                                },
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.purple),
                                decoration: InputDecoration(
                                  label: const Text(
                                    'Password',
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.purple),
                                  ),
                                  hintText: 'Password.',
                                  prefix: const Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                  suffix: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.visibility,
                                        color: Colors.grey,
                                      )),
                                  contentPadding: const EdgeInsets.symmetric(
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
                                bottom: 10,
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
                                    fontSize: 14.0, color: Colors.purple),
                                decoration: InputDecoration(
                                  label: const Text('Address'),
                                  hintText: 'Address',
                                  // prefix: const Icon(
                                  //   Icons.my_location,
                                  //   color: Colors.grey,
                                  // ),
                                  suffix: IconButton(
                                    onPressed: () async {
                                      _getCurrentLocation();
                                      setState(
                                        () {
                                          address.text = latitudeData +
                                              " " +
                                              longitudeData;
                                        },
                                      );
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
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  //////////////buttons///////////////

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(15)),
                        // foregroundColor:
                        //     MaterialStateProperty.all<Color>(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                            side: const BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      onPressed: () {
                        // validationAndSave;
                        registerUsers(email.text, password.text);
                        Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            Text(""),
                          ],
                        ));
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),

                  TextButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('Login clicked');
                      }
                      Navigator.of(context)
                          .pushReplacementNamed(LogIn.routeName);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Divider(
                      height: 4.0,
                      color: Colors.grey,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: const Text(
                        "SOCORO",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple),
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

  Future<void> registerUsers(String email, String password) async {
    final _auth = FirebaseAuth.instance;
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirebase(),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: "Failed to login!" + e!.message);
      });
    }
  }

  postDetailsToFirebase() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    //writing to firebase
    //adding the details to the constructor
    userModel.uid = user?.uid;
    userModel.email = email.text;
    userModel.password = password.text;
    userModel.fullName = fullName.text;
    userModel.phoneNumber = phoneNumber.text;
    userModel.address = address.text;

    await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "account created successfully");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const EmergencyType()),
        result: (route) => false);
  }
}
