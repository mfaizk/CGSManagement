import 'package:CGSManagement/Screens/feeEntryScreen.dart';
import 'package:CGSManagement/Screens/homeScreen.dart';
import 'package:CGSManagement/Screens/infoScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditdetailScreen extends StatefulWidget {
  final String studentClass;
  final String studentId;
  EditdetailScreen(
      {Key key, @required this.studentClass, @required this.studentId})
      : super(key: key);
  @override
  _EditdetailScreenState createState() => _EditdetailScreenState();
}

class _EditdetailScreenState extends State<EditdetailScreen> {
  String studentName = 'empty';
  String fName = 'empty';
  String gender = 'empty';
  String dob = 'empty';
  String studentSection = 'empty';
  String isLoading = 'false';
  TextEditingController studentNameC = TextEditingController();
  TextEditingController fNameC = TextEditingController();

  TextEditingController genderC = TextEditingController();

  TextEditingController dobC = TextEditingController();

  TextEditingController studentSectionC = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getDataForEditing();
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
      if (value != null) {
        setState(() {
          dob = value.toString().substring(0, 10);
        });
      }
    });
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

  getDataForEditing() async {
    setState(() {
      isLoading = 'true';
    });
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('StudentInfo')
          .child(widget.studentClass)
          .child(widget.studentId)
          .once()
          .then((value) {
        setState(() {
          studentNameC.text = value.value['StudentName'];

          gender = value.value['Gender'];
          dob = value.value['Dob'];
          fNameC.text = value.value['FatherName'];

          studentSectionC.text = value.value['section'];
          isLoading = 'false';
        });
      });
    } on FirebaseException catch (e) {
      errorAlert(e.message);
    }
  }

  updateData() async {
    setState(() {
      isLoading = 'true';
    });

    try {
      FirebaseDatabase.instance
          .reference()
          .child('StudentInfo')
          .child(widget.studentClass)
          .child(widget.studentId)
          .update({
        'StudentName': studentNameC.text,
        'Gender': gender,
        'Dob': dob,
        'FatherName': fNameC.text,
        'section': studentSectionC.text,
      }).whenComplete(() {
        Fluttertoast.showToast(
            msg: 'Sucessfully updated',
            textColor: Colors.white,
            backgroundColor: Colors.green,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
        backtoHome();
      });
    } on FirebaseException catch (e) {
      errorAlert(e.message);
    }
  }

  backtoHome() {
    setState(() {
      isLoading = 'false';
    });
    Navigator.pop(context, MaterialPageRoute(
      builder: (context) {
        return InfoScreen(
            studentClass: widget.studentClass, studentId: widget.studentId);
      },
    ));
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
                child: Text('Update Info'),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                color: Colors.white,
                child: Card(
                  child: Form(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                  icon: Icon(Icons.perm_identity),
                                  labelStyle:
                                      TextStyle(color: Color(0xff7d5fff)),
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
                                  fName = value;
                                });
                              },
                              controller: fNameC,
                              validator: (value) {
                                if (fName == null) {
                                  return 'Enter Father Name';
                                } else {
                                  setState(() {
                                    fName = value;
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
                                  icon: Icon(Icons.perm_identity),
                                  labelStyle:
                                      TextStyle(color: Color(0xff7d5fff)),
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
                                  studentSection = value;
                                });
                              },
                              controller: studentSectionC,
                              validator: (value) {
                                if (studentSection == null) {
                                  return 'Enter StudentName';
                                } else {
                                  setState(() {
                                    studentSection = value;
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
                                  icon: Icon(Icons.perm_identity),
                                  labelStyle:
                                      TextStyle(color: Color(0xff7d5fff)),
                                  fillColor: Colors.purple),
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
                          Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.01)),
                          ListTile(
                            title: Text('Select Dob'),
                            trailing: GestureDetector(
                              onTap: () {
                                showDateTimePicker(context);
                              },
                              child: dob == null ? Text('Select') : Text(dob),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.02),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: RaisedButton(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () {
                                updateData();
                              },
                              child: FittedBox(
                                child: Text(
                                  'Update',
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
              ),
            ),
          );
  }
}
