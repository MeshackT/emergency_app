import 'package:afpemergencyapplication/LoginAndRegisterScreens/LogIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);
  static const routeName = '/passwordReset';

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset>
    with WidgetsBindingObserver {
  TextEditingController email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

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
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.pushReplacementNamed(context, LogIn.routeName);
          },
        ),
        backgroundColor: Colors.green,
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
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

                ///////Reset header/////////////
                Divider(
                  height: 8.0,
                  color: Colors.green[100],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                  child: const Center(
                      child: Text(
                    "Reset Password",
                    style: TextStyle(color: Colors.purple, fontSize: 20.0),
                  )),
                ),

                ////////Card////////
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                  child: Expanded(
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
                              margin:
                                  const EdgeInsets.only(bottom: 20, top: 20),
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
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(15)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      side:
                                          const BorderSide(color: Colors.green),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();

                                    //get the user information
                                    _passwordReset(
                                      email.text,
                                    );

                                    setState(() {
                                      // progressBar = true;
                                      email.clear();
                                    });
                                  }
                                },
                                child: const Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
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
                                    context, LogIn.routeName);
                              },
                              child: const Text(
                                "LogIn",
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

  Future<void> _passwordReset(String email) async {
    final _auth = FirebaseAuth.instance;
    try {
      return _auth.sendPasswordResetEmail(email: email).whenComplete(
            () => Fluttertoast.showToast(
                msg: 'An email has been sent to the provided email address.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.grey,
                fontSize: 16.0,
                backgroundColor: Colors.white),
          );
    } on FirebaseAuthException catch (e) {
      //if user is not found then display this msg
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: 'No user found for that email.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.grey,
            fontSize: 16.0);

        setState(() {
          // progressBar = false;
        });
      }
    }
  }
}
