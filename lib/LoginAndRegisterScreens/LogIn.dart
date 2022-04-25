import 'package:afpemergencyapplication/LoginAndRegisterScreens/PasswordReset.dart';
import 'package:afpemergencyapplication/MainSreens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';

import 'UserRegister.dart';

final LocalStorage storage = LocalStorage('localstorage_app');

class LogIn extends StatefulWidget {
  static const routeName = '/login';
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Logger log = Logger();
  bool passwordVisible = true;

  bool validationAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return false;
    }
    return true;
  }

  //controllers
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ////////Icon Logo////////
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Icon(
                      Icons.my_location,
                      size: 60,
                      color: Colors.green,
                    ),
                  ),
                ),

                ///////Login header/////////////
                Divider(
                  height: 8.0,
                  color: Colors.green[100],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                  child: const Center(
                      child: Text(
                    "LogIn",
                    style: TextStyle(color: Colors.purple, fontSize: 20.0),
                  )),
                ),

                ////////Card////////
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                  child: Card(
                    elevation: 2.0,
                    shadowColor: Colors.green,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20, top: 20),
                            child: TextFormField(
                              controller: email,
                              onSaved: (value) {
                                setState(() {
                                  email.text = value!;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Enter an email");
                                }
                                if (!value.contains("@")) {
                                  return ("Please Enter a valid valid email");
                                }
                                return null;
                              },
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.purple),
                              decoration: const InputDecoration(
                                label: Text('Email'),
                                hintText: 'Email',
                                prefix: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: TextFormField(
                              controller: password,
                              onSaved: (value) {
                                setState(() {
                                  password.text = value!;
                                });
                              },
                              validator: (value) {
                                RegExp regex = RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return ("Enter password");
                                }
                                if (value.length < 5) {
                                  return ("Your password is too short!");
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("password min of 6 characters");
                                }
                              },
                              textAlign: TextAlign.center,
                              obscureText: passwordVisible,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.purple),
                              decoration: InputDecoration(
                                label: const Text('Password'),
                                hintText: 'Enter Password.',
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
                          const SizedBox(
                            height: 15.0,
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
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    side: const BorderSide(color: Colors.green),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  _userSignIn(email.text, password.text);
                                }
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
                                "LogIn",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(UserRegister.routeName);
                            },
                            child: const Text(
                              "Register",
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
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, PasswordReset.routeName);
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 80.0, right: 80.0, top: 20.0),
                  child: Divider(
                    height: 10.0,
                    color: Colors.grey,
                  ),
                ),

                /////////Footer////////
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    alignment: Alignment.center,
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
    );
  }

  Future<User?> _userSignIn(String email, String password) async {
    final _auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await _auth
          .signInWithEmailAndPassword(
              email: email.trim().toLowerCase(), password: password.trim())
          .then((uid) => {
                log.i(user!.uid + " logged in"),
                Fluttertoast.showToast(msg: "Login Success"),
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmergencyType()),
                    (route) => false),
              });
    } on FirebaseAuthException catch (e) {
      //if user is not found then display this msg
      if (e.code == 'user-not-found') {
        log.i("user not found!");
        Fluttertoast.showToast(
            msg: 'No user found for that email.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.grey,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password') {
        log.i("wrong password");
        Fluttertoast.showToast(
            msg: 'Wrong password provided for that user.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.grey,
            fontSize: 16.0);
      }
    }
  }
}
