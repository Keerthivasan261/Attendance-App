import 'package:attendance_app/Constants/ExtractWidgets.dart';
import 'package:flutter/material.dart';

class DeptPage extends StatefulWidget {
  static const String id = "DeptPage";

  @override
  _DeptPageState createState() => _DeptPageState();
}

class _DeptPageState extends State<DeptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: Theme.of(context).iconTheme,
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
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0.12,
                        blurRadius: 7,
                        color: Colors.grey,
                      )
                    ],
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Select your department",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentIconTheme.color),
                            ),
                          ),
                          EditedText(
                            Dept: cse,
                          ),
                          EditedText(
                            Dept: eee,
                          ),
                          EditedText(
                            Dept: ece,
                          ),
                          EditedText(
                            Dept: civil,
                          ),
                          EditedText(
                            Dept: mech,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KMyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height + 50, size.width, size.height - 70);
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
