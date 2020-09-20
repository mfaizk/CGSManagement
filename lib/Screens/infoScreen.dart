import 'package:CGSManagement/Screens/editdetailScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class InfoScreen extends StatefulWidget {
  final String studentClass;
  final String studentId;
  InfoScreen({Key key, @required this.studentClass, @required this.studentId})
      : super(key: key);

  static const String id = 'chat';
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String fee = 'nil';
  String studentName = 'empty';
  String studentId = 'empty';
  String gender = 'empty';
  String dob = 'empty';
  String fName = 'empty';
  String studentClass = 'empty';
  String studentSection = 'empty';
  String isLoading = 'false';

  @override
  void initState() {
    super.initState();
    print(widget.studentClass);
    print(widget.studentId);
    getData();
  }

  getData() async {
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
          studentName = value.value['StudentName'];
          studentId = value.value['StudentId'];
          gender = value.value['Gender'];
          dob = value.value['Dob'];
          fName = value.value['FatherName'];
          studentClass = value.value['StudentClass'];
          studentSection = value.value['section'];
          isLoading = 'false';
        });
      }).whenComplete(() => fetchFee());
    } on FirebaseException catch (e) {
      errorAlert(e.message);
    }
  }

  fetchFee() async {}

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
              title: Text('Info'),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text('Student Name:'),
                            trailing: Text(studentName),
                          ),
                          ListTile(
                            title: Text('Class:'),
                            trailing: Text(studentClass),
                          ),
                          ListTile(
                            title: Text('DOB:'),
                            trailing: Text(dob),
                          ),
                          ListTile(
                            title: Text('Father Name:'),
                            trailing: Text(fName),
                          ),
                          ListTile(
                            title: Text('Gender:'),
                            trailing: Text(gender),
                          ),
                          ListTile(
                            title: Text('Section:'),
                            trailing: Text(studentSection),
                          ),
                          ListTile(
                            title: Text('Id:'),
                            trailing: Text(studentId),
                          ),
                          ListTile(
                            title: Text('Fee'),
                            trailing: Text(fee),
                          ),
                          Divider(),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    color: Colors.green,
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return EditdetailScreen(
                                              studentClass: widget.studentClass,
                                              studentId: widget.studentId);
                                        },
                                      ));
                                    },
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        'Edit Detail',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    color: Colors.blue,
                                    onPressed: () {},
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        'Enter Fee',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
