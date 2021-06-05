import 'package:attendance_app/LoadingBox.dart';
import 'package:attendance_app/Screens/MainPageContent/DeptPage.dart';
import 'package:attendance_app/Screens/LoginScreen.dart';
import 'package:attendance_app/MyTheme.dart';
import 'package:attendance_app/Screens/MainPage.dart';
import 'package:attendance_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "RegistrationScreen";

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Column(
                children: [
                  Container(
                    child: AppBar(
                      leading: Consumer<MyTheme>(
                        builder: (context, theme, child) => IconButton(
                          icon: Icon(theme.isLightTheme
                              ? MdiIcons.mine
                              : MdiIcons.moonWaningCrescent),
                          color: Theme.of(context).iconTheme.color,
                          iconSize: 25,
                          onPressed: () {
                            theme.ChangeTheme();
                          },
                        ),
                      ),
                    ),
                    height: 280,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 5,
                            color: Colors.black),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Text(
                "Signup",
                style: TextStyle(
                    shadows: [
                      Shadow(
                          color: Colors.grey.shade400,
                          blurRadius: 6,
                          offset: Offset(1.2, 1))
                    ],
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            KTextField(
              obscureText: false,
              keyboardType: TextInputType.name,
              hintText: "Username",
              controller: usernameController,
              icons: MdiIcons.account,
            ),
            KTextField(
              obscureText: false,
              keyboardType: TextInputType.phone,
              hintText: "Phone Number",
              controller: phoneNumberController,
              icons: MdiIcons.phone,
            ),
            KTextField(
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              hintText: "Email-ID",
              controller: emailIDController,
              icons: MdiIcons.email,
            ),
            KTextField(
              obscureText: opened?false:true,
              keyboardType: TextInputType.text,
              hintText: "Password",
              controller: passwordController,
              icons: MdiIcons.lock,
              suffixIcon: IconButton(icon: opened?Icon(MdiIcons.eye):Icon(MdiIcons.eyeOff,),onPressed: (){
                setState(() {
                  opened=!opened;
                });
              },),
            ),
            SizedBox(
              height: 25,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
                shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                elevation: MaterialStateProperty.all(5),
              ),
              onPressed: () {
                checkInfo(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Text(
                  "Register Account",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.id, (route) => false);
                },
                child: Text(
                  "Already have an account? Login here",
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 19),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  checkInfo(BuildContext context) {
    if (usernameController.text.length < 3) {
      displayToastMessage(context, "Username is not valid");
    } else if (phoneNumberController.text.length < 6) {
      displayToastMessage(context, 'Phone number not valid');
    } else if (!emailIDController.text.contains('@')) {
      displayToastMessage(context, "Email-ID is not valid");
    } else if (passwordController.text.length < 6) {
      displayToastMessage(context, 'Password must be more than 6');
    } else {
      registerAccount(context);
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future registerAccount(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingBox();
      },
    );
    final User firebaseUser = (await _auth
            .createUserWithEmailAndPassword(
                email: emailIDController.text,
                password: passwordController.text)
            .catchError(
      (error) {
        Navigator.pop(context);
        displayToastMessage(context, "Error! $error");
      },
    ))
        .user;
    print(userRef.child(firebaseUser.uid).child("username"));
    if (firebaseUser != null) {
      Map userData = {
        "Username": usernameController.text,
        "PhoneNumber": phoneNumberController.text,
        "Email-Id": emailIDController.text,
        "Position": "Student",
      };
      userRef.child(firebaseUser.uid).set(userData).asStream();
      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
      displayToastMessage(context, "\'You Signed up successfully\'");
    } else {
      Navigator.pop(context);
      displayToastMessage(context, 'User is not created! Invalid details');
    }
  }
}

displayToastMessage(BuildContext context, String message) {
  Fluttertoast.showToast(
    msg: message,
    textColor: Colors.black,
    fontSize: 16,
    backgroundColor: Colors.grey[400],
  );
}

class KTextField extends StatelessWidget {
  final bool obscureText;
  final TextInputType keyboardType;
  final String hintText;
  final TextEditingController controller;
  final IconData icons;
  final Widget suffixIcon;

  KTextField(
      {this.icons,this.suffixIcon,this.obscureText, this.keyboardType, this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Consumer<MyTheme>(
        builder: (context, theme, child) => Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    spreadRadius: 1,
                    color: theme.isLightTheme ? Colors.grey : Colors.grey[700],
                    blurRadius: 10,
                    offset: Offset(1, 3))
              ]),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              prefixIcon: Icon(icons),
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
