import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  String studentName;
  String studentClass = 'empty';
  String studentUniqueId;
  String fatherName;
  String studentClassSection;
  String gender = 'empty';
  String dob = 'empty';
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController fatherNameC = TextEditingController();

  TextEditingController studentNameC = TextEditingController();
  TextEditingController studentUniqueIdC = TextEditingController();
  TextEditingController studentClassSectionC = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String isLoading = 'false';

  fieldClear() async {
    setState(() {
      studentNameC.clear();
      studentClassSectionC.clear();
      studentUniqueIdC.clear();
      fatherNameC.clear();
      gender = 'empty';
      dob = 'empty';
      studentClass = 'empty';
    });
  }

  showDateTimePicker(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2050),
      initialDatePickerMode: DatePickerMode.year,
      confirmText: 'Ok',
      fieldLabelText: 'Date Of Birth',
    ).then((value) {
      setState(() {
        dob = value.toString().substring(0, 10);
      });
    });
  }

  saveDataToDataBase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentSession = prefs.getString('year');
    setState(() {
      isLoading = 'true';
    });
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('StudentInfo')
          .child(currentSession)
          .child(studentClass)
          .child(studentUniqueId)
          .set({
        'StudentName': studentName,
        'StudentClass': studentClass,
        'StudentId': studentUniqueId,
        'FatherName': fatherName,
        'Gender': gender,
        'Dob': dob,
        'section': studentClassSection,
      }).whenComplete(() {
        fieldClear();
        Fluttertoast.showToast(
          msg: 'SucessFully Registered',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        setState(() {
          isLoading = 'false';
        });
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = 'false';
      });
      errorAlert(e.message);
    }
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
    return isLoading == 'true'
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: FittedBox(
                child: Text('Add Student'),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                child: Form(
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          title: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                studentUniqueId = value;
                              });
                            },
                            controller: studentUniqueIdC,
                            validator: (value) {
                              if (studentUniqueId == null) {
                                return 'Enter StudentName';
                              } else {
                                setState(() {
                                  studentUniqueId = value;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'UniqueId',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                icon: Icon(Icons.perm_identity),
                                labelStyle: TextStyle(color: Color(0xff7d5fff)),
                                fillColor: Colors.purple),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.01)),
                        ListTile(
                          title: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                fatherName = value;
                              });
                            },
                            controller: fatherNameC,
                            validator: (value) {
                              if (fatherName == null) {
                                return 'Enter Father Name';
                              } else {
                                setState(() {
                                  fatherName = value;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Father Name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                icon: Icon(Icons.home),
                                labelStyle: TextStyle(color: Color(0xff7d5fff)),
                                fillColor: Colors.purple),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.01)),
                        ListTile(
                          title: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                studentName = value;
                              });
                            },
                            controller: studentNameC,
                            validator: (value) {
                              if (studentName == null) {
                                return 'Enter StudentName';
                              } else {
                                setState(() {
                                  studentName = value;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Student Name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                icon: Icon(Icons.email),
                                labelStyle: TextStyle(color: Color(0xff7d5fff)),
                                fillColor: Colors.purple),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.01)),
                        ListTile(
                          title: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                studentClassSection = value;
                              });
                            },
                            controller: studentClassSectionC,
                            validator: (value) {
                              if (studentClassSection == null) {
                                return 'Enter StudentName';
                              } else {
                                setState(() {
                                  studentClassSection = value;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Student Section',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                icon: Icon(Icons.supervisor_account),
                                labelStyle: TextStyle(color: Color(0xff7d5fff)),
                                fillColor: Colors.purple),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.01)),
                        ListTile(
                          leading: Text('Select Class'),
                          trailing: DropdownButton<String>(
                            icon: Icon(Icons.arrow_drop_down),
                            value: (this.studentClass == 'empty')
                                ? null
                                : this.studentClass,
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
                                studentClass = newValue;
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
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.01)),
                        ListTile(
                          leading: Text('Select Gender'),
                          trailing: DropdownButton<String>(
                            icon: Icon(Icons.arrow_drop_down),
                            value: (this.gender == 'empty') ? null : gender,
                            hint: Text('Select Gender'),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                gender = newValue;
                              });
                            },
                            items: <String>[
                              'Male',
                              'Female',
                              'Other',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        ListTile(
                          title: Text('Select Dob'),
                          trailing: GestureDetector(
                            onTap: () {
                              showDateTimePicker(context);
                            },
                            child:
                                dob == null ? Text('Select') : Text(this.dob),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.02),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: Colors.green,
                            onPressed: () async {
                              if (_key.currentState.validate()) {
                                _key.currentState.save();
                                if (gender != 'empty' &&
                                    dob != 'empty' &&
                                    studentClass != 'empty') {
                                  saveDataToDataBase();
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'Please Enter data',
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                }
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              child: Text('Save Data'),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
  }
}
