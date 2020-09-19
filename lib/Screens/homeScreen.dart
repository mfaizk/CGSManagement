import 'package:CGSManagement/Screens/addStudent.dart';
import 'package:CGSManagement/Screens/infoScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedYear = 'empty';
  String selectedClass = 'empty';
  String isLoading = 'false';
  String id;
  TextEditingController idC = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
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

  yearSelection() {
    Alert(
      style: AlertStyle(
          isOverlayTapDismiss: false,
          isCloseButton: false,
          alertBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      context: context,
      title: "Enter Session Year",
      content: ListTile(
        leading: Text('Select Year'),
        trailing: DropdownButton<String>(
          icon: Icon(Icons.arrow_drop_down),
          value: (this.selectedYear == 'empty') ? null : this.selectedYear,
          hint: Text('Select Year'),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) async {
            setState(() {
              selectedYear = newValue;
            });
          },
          items: <String>[
            '2019',
            '2020',
            '2021',
            '2022',
            '2023',
            '2024',
            '2025'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
      buttons: [
        DialogButton(
            color: Colors.white,
            child: Text(
              "ok",
              style: TextStyle(color: Colors.red, fontSize: 25),
            ),
            onPressed: () {
              yearSetter();
              Navigator.of(context, rootNavigator: true).pop();
            })
      ],
    ).show();
  }

  yearSetter() async {
    print(selectedYear);
    if (selectedYear != 'empty') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('year', selectedYear);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    sessionChecker();
  }

  sessionChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String enteredYear = prefs.getString('year');
    print(enteredYear);
    if (enteredYear == null) {
      yearSelection();
    }
  }

  forceSessionChange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('year');
    sessionChecker();
  }

  checkStudentExistOrNotInDataBase() async {
    setState(() {
      isLoading = 'true';
    });

    await FirebaseDatabase.instance
        .reference()
        .child('StudentInfo')
        .child(selectedClass)
        .child(id)
        .once()
        .then((value) {
      if (value.value == null) {
        setState(() {
          isLoading = 'false';
        });
        idC.clear();
        Fluttertoast.showToast(
            msg: 'No Student found',
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      } else {
        Fluttertoast.showToast(
                msg: 'Record Found',
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_LONG)
            .whenComplete(() {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return InfoScreen(studentClass: selectedClass, studentId: id);
            },
          ));
        });
        setState(() {
          isLoading = 'false';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Area'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('CGS'),
            ),
            ListTile(
              title: Text('Change Session'),
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
                forceSessionChange();
              },
            ),
            ListTile(
              title: Text('SignOut'),
              onTap: () {
                signOut();
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading == 'true'
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Form(
                key: _key,
                child: Container(
                  height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        title: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              id = value;
                            });
                          },
                          controller: idC,
                          validator: (value) {
                            if (id == null) {
                              return 'Enter UniqueId';
                            } else {
                              setState(() {
                                id = value;
                              });
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'UniqueId',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              icon: Icon(Icons.child_care),
                              labelStyle: TextStyle(color: Color(0xff7d5fff)),
                              fillColor: Colors.purple),
                        ),
                      ),
                      ListTile(
                        leading: Text('Select Class'),
                        trailing: DropdownButton<String>(
                          icon: Icon(Icons.arrow_drop_down),
                          value: (this.selectedClass == 'empty')
                              ? null
                              : this.selectedClass,
                          hint: Text('Select Class'),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              selectedClass = newValue;
                            });
                          },
                          items: <String>[
                            '1',
                            '2',
                            '3',
                            '4',
                            '5',
                            '6',
                            '7',
                            '8',
                            '9',
                            '10'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              if (selectedClass != 'empty') {
                                checkStudentExistOrNotInDataBase();
                              }
                            }
                          },
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            child: Text(
                              'G e t',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddStudent();
            },
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
