import 'package:attendance_app/LoadingBox.dart';
import 'package:attendance_app/MyTheme.dart';
import 'package:attendance_app/Screens/MainPage.dart';
import 'package:attendance_app/Screens/RegistrationScreen.dart';
import 'package:attendance_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "LoginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    height: 300,
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
              padding: const EdgeInsets.only(top: 80, bottom: 10),
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            KTextField(
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              controller: emailIDController,
              hintText: "Email-ID",
              icons: MdiIcons.email,
            ),
            KTextField(
              obscureText: opened?false:true,
              keyboardType: TextInputType.text,
              controller: passwordController,
              hintText: "Password",
              icons: MdiIcons.lock,
              suffixIcon: IconButton(icon: opened?Icon(MdiIcons.eye):Icon(MdiIcons.eyeOff,),onPressed: (){
                setState(() {
                  opened=!opened;
                });
              },),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                ),
                child: TextButton(
                  onPressed: () async{
                    await _auth.sendPasswordResetEmail(email: emailIDController.text);
                    displayToastMessage(context, "Password Reset mail sent");
                  },
                  child: Text(
                    "Forget Password?",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).accentColor),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                checkInfo(context);
              },
              child: Container(
                width: 130,
                height: 40,
                child: Center(
                  child: Text(
                    "Login",
                    style: GoogleFonts.openSans(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0.2,
                      blurRadius: 8,
                      color: Theme.of(context).accentColor,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegistrationScreen.id, (route) => false);
                },
                child: Text(
                  "Don't have an account? Register here",
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  checkInfo(BuildContext context) {
    if (!emailIDController.text.contains('@')) {
      displayToastMessage(context, "Email-ID is not valid");
    } else if (passwordController.text.length < 6) {
      displayToastMessage(context, 'Password is not valid');
    } else {
      loginAccount(context);
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loginAccount(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingBox();
      },
    );
    final User firebaseUser = (await _auth.signInWithEmailAndPassword(
        email: emailIDController.text,
        password: passwordController.text)
        .catchError(
          (error){
            displayToastMessage(context, "Error! $error");
            },
    )
    ).user;
    print(userRef.child(firebaseUser.uid).child("username"));
    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          displayToastMessage(context, "\'You Logged In successfully\'");
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.id, (route) => false);
        } else {
          _auth.signOut();
          Navigator.pop(context);
          displayToastMessage(context, "Username or password is incorrect");
        }
      });
    } else {
      _auth.signOut();
      Navigator.pop(context);
      displayToastMessage(context, 'Error! Invalid details');
    }
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 4, size.height + 10,
        size.width - (size.width / 3), size.height - 40);
    path.quadraticBezierTo(size.width - (size.width / 7), size.height - 50,
        size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
