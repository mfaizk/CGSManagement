import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeeEntryScreen extends StatefulWidget {
  final String studentClass;
  final String studentId;
  FeeEntryScreen(
      {Key key, @required this.studentClass, @required this.studentId})
      : super(key: key);
  @override
  _FeeEntryScreenState createState() => _FeeEntryScreenState();
}

class _FeeEntryScreenState extends State<FeeEntryScreen> {
  String curentSession = 'empty';
  String isLoading = 'false';
  String month = 'empty';
  int amnt = 0;
  List keydata;
  TextEditingController amtC = TextEditingController();

  getCurrentSession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cSession = preferences.getString('year');
    setState(() {
      curentSession = cSession;
    });
    print(curentSession);
  }

  trialFxn() {
    print('hey');
  }

  errorAlert(message) {
    setState(() {
      isLoading = 'false';
    });
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

  uploadFeeDetail() async {
    setState(() {
      isLoading = 'true';
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cSession = preferences.getString('year');
    if (curentSession != 'empty' && amnt != 0 && month != 'empty') {
      try {
        FirebaseDatabase.instance
            .reference()
            .child(cSession)
            .child(widget.studentClass)
            .child(widget.studentId)
            .push()
            .set({'fee': amnt, 'month': month, 'time': DateTime.now()});
        setState(() {
          isLoading = 'false';
        });
      } on FirebaseException catch (e) {
        errorAlert(e.message);
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Oops',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // getInitialData() async {
  //   try {
  //     FirebaseDatabase.instance
  //         .reference()
  //         .child(curentSession)
  //         .child(widget.studentClass)
  //         .child(widget.studentId)
  //         .once()
  //         .then((value) {
  //       if (value.key != null) {
  //         print(value.key);
  //       }
  //     });
  //   } on FirebaseException catch (e) {
  //     errorAlert(e.message);
  //   }
  // }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    trialFxn();
    getCurrentSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.contain,
          child: Text('Fee Entry $curentSession'),
        ),
      ),
      body: isLoading == 'true'
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01)),
                    Card(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              icon: Icon(Icons.arrow_drop_down),
                              value: (this.month == 'empty') ? null : month,
                              hint: Text('Select Month'),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  month = newValue;
                                });
                              },
                              items: <String>[
                                'January',
                                'Febraury',
                                'March',
                                'April',
                                'May',
                                'June',
                                'July',
                                'August',
                                'September',
                                'October',
                                'November',
                                'December',
                                'Discount',
                                'Extra',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    amnt = int.parse(value);
                                  });
                                },
                                controller: amtC,
                                validator: (value) {
                                  if (amnt == null) {
                                    return 'Enter StudentName';
                                  } else {
                                    setState(() {
                                      amnt = int.parse(value);
                                    });
                                  }
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelText: 'Fee',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    labelStyle:
                                        TextStyle(color: Color(0xff7d5fff)),
                                    fillColor: Colors.purple),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01)),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        color: Colors.green,
                        onPressed: () {
                          // getInitialData();
                        },
                        child: FittedBox(
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          child: Text(
                            'Upload',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
    );
  }
}
