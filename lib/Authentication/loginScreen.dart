import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  String email;
  String pass;
  String isloading = 'false';
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  Future sigin() async {
    setState(() {
      isloading = 'true';
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass)
          .whenComplete(() => clearField());
    } on FirebaseAuthException catch (e) {
      clearField();
      errorAlert(e.message);
    }
  }

  clearField() {
    setState(() {
      isloading = 'false';
    });
    emailC.clear();
    passC.clear();
  }

  errorAlert(message) {
    print(message);
    Alert(
      style: AlertStyle(
          isCloseButton: false,
          alertBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      context: context,
      title: "Error",
      desc: message,
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "Close",
            style: TextStyle(color: Colors.red, fontSize: 25),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return isloading == 'true'
        ? Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                color: Color(0xff0A79DF),
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 10,
                    color: Color(0xff4834DF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 1,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      wordSpacing: 20.0),
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                      child: Form(
                                        key: _key,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.02)),
                                            TextFormField(
                                              controller: emailC,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter Email';
                                                } else {
                                                  setState(() {
                                                    email = value;
                                                  });
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  labelText: 'Email',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .auto,
                                                  icon: Icon(Icons.email),
                                                  labelStyle: TextStyle(
                                                      color: Color(0xff7d5fff)),
                                                  fillColor: Colors.purple),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.02)),
                                            TextFormField(
                                              controller: passC,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter Password';
                                                } else {
                                                  setState(() {
                                                    pass = value;
                                                  });
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  labelText: 'Password',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .auto,
                                                  icon: Icon(Icons.lock),
                                                  labelStyle: TextStyle(
                                                      color: Color(0xff7d5fff)),
                                                  fillColor: Colors.purple),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.02)),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.34,
                                              color: Colors.white,
                                              child: RaisedButton(
                                                color: Color(0xff7d5fff),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                onPressed: () {
                                                  if (_key.currentState
                                                      .validate()) {
                                                    _key.currentState.save();
                                                    sigin();
                                                  }
                                                },
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Text(
                                                    'Login',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.02)),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          );
  }
}
