import 'package:attendance_app/MyTheme.dart';
import 'package:attendance_app/Screens/MainPageContent/DeptPage.dart';
import 'package:attendance_app/Screens/RegistrationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class StudentList extends StatefulWidget {
  static const id = "StudentList";

  final String deptName;
  final String yr;
  final String section;

  StudentList({this.deptName, this.yr, this.section});

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  DatabaseReference _StudRef;
  final referenceDatabase = FirebaseDatabase.instance;
  TextEditingController _registerNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailIdController = TextEditingController();

  Widget buildDialog(BuildContext context) {
    return Dialog(
        child: Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Column(children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(MdiIcons.close),
                iconSize: 25,
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  DialogTextField(
                    keyboardType: TextInputType.number,
                    controller: _registerNumberController,
                    name: "Register Number",
                  ),
                  DialogTextField(
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    name: "Student Name",
                  ),
                  DialogTextField(
                    keyboardType: TextInputType.number,
                    controller: _phoneNumberController,
                    name: "Mobile Number",
                  ),
                  DialogTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailIdController,
                    name: "Email-Id",
                  ),
                ],
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              checkNotEmpty();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Theme.of(context).primaryColor,
            child: Text(
              "Add",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          )
        ]),
      ),
    ));
  }

  checkNotEmpty() {
    if (_registerNumberController.text.length != 12) {
      displayToastMessage(context, "Invalid Register Number");
    } else if (_nameController.text.length < 3) {
      displayToastMessage(context, "Enter Full name");
    } else if (_phoneNumberController.text.length != 10) {
      displayToastMessage(context, "Invalid Mobile Number");
    } else {
      Map userData = {
        "RegisterNumber": _registerNumberController.text,
        "Name": _nameController.text,
        "PhoneNumber": _phoneNumberController.text,
        "EmailID": _emailIdController.text
      };
      final newStud = referenceDatabase.reference();

      newStud
          .child(widget.deptName)
          .child(widget.yr)
          .child(widget.section)
          .child(_registerNumberController.text)
          .set(userData)
          .asStream();
      _registerNumberController.clear();
      _nameController.clear();
      _phoneNumberController.clear();
      _emailIdController.clear();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    final FirebaseDatabase database = FirebaseDatabase();
    _StudRef = database
        .reference()
        .child(widget.deptName)
        .child(widget.yr)
        .child(widget.section);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final provider = Provider.of<MyTheme>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          provider.isStudent?SizedBox(width: 0,):PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: TextButton(
                    onPressed: () {
                      showDialog(context: context, builder: buildDialog);
                    },
                    child: Container(
                      child: Text(
                        "Add student",
                        style: TextStyle(
                            fontSize: 18, color: Theme.of(context).accentColor),
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: KMyClipper(),
              child: Container(
                height: 250,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
              child: Container(
                padding: EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 7,
                      color: Colors.grey,
                    )
                  ],
                  color: Theme.of(context).backgroundColor,
                ),
                child: FirebaseAnimatedList(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    query: _StudRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      return ExpansionTile(
                        title: Text(
                          snapshot.value['RegisterNumber'],
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).accentIconTheme.color
                          ),
                        ),
                        expandedAlignment: Alignment.centerLeft,
                        children: [
                          kRichText(
                            lText: "Register No: ",
                            rText: snapshot.value['RegisterNumber'],
                          ),
                          kRichText(
                            lText: "Student Name: ",
                            rText: snapshot.value['Name'],
                          ),
                          kRichText(
                            lText: "Mobile Number: ",
                            rText: snapshot.value['PhoneNumber'],
                          ),
                          kRichText(
                            lText: "Email-Id: ",
                            rText: snapshot.value['EmailID'],
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class kRichText extends StatelessWidget {
  final String lText;
  final String rText;

  kRichText({this.lText, this.rText});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: lText, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18)),
          TextSpan(
              text: rText, style: TextStyle(color: Theme.of(context).accentIconTheme.color, fontSize: 18))
        ])),
      ),
    );
  }
}

class DialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final TextInputType keyboardType;

  DialogTextField(
      {@required this.name,
      @required this.controller,
      @required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                    width: 2.5, color: Theme.of(context).primaryColor)),
            hintText: name,
            hintStyle: TextStyle(color: Colors.grey[600])),
      ),
    );
  }
}
