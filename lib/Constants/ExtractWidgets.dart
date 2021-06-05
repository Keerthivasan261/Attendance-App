import 'package:attendance_app/Constants/ImageFile.dart';
import 'package:attendance_app/MyTheme.dart';
import 'package:attendance_app/Screens/MainPageContent/StudentList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String cse = "CSE";
const String ece = "ECE";
const String eee = "EEE";
const String civil = "CIVIL";
const String mech = "MECH";
const List yr = [
  "I yr",
  "II yr",
  "III yr",
  "IV yr",
];
const List section = ["A", "B"];

class EditedText extends StatelessWidget {
  final String Dept;

  EditedText({
    this.Dept,
  });

  @override
  Widget build(BuildContext context) {
    return KExpansionTile(
        deptName: Dept,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        fontColor: Theme.of(context).iconTheme.color,
        widgets: [
          KExpansionTile(
            deptName: yr[0],
            fontSize: 18,
            fontWeight: FontWeight.w300,
            widgets: [
              DeptContainer(section: section[0], deptName: Dept, yr: yr[0]),
              DeptContainer(section: section[1], deptName: Dept, yr: yr[0]),
            ],
          ),
          KExpansionTile(
            deptName: yr[1],
            fontSize: 18,
            fontWeight: FontWeight.w300,
            widgets: [
              DeptContainer(section: section[0], deptName: Dept, yr: yr[1]),
              DeptContainer(section: section[1], deptName: Dept, yr: yr[1]),
            ],
          ),
          KExpansionTile(
            deptName: yr[2],
            fontSize: 18,
            fontWeight: FontWeight.w300,
            widgets: [
              DeptContainer(section: section[0], deptName: Dept, yr: yr[2]),
              DeptContainer(section: section[1], deptName: Dept, yr: yr[2]),
            ],
          ),
          KExpansionTile(
            deptName: yr[3],
            fontSize: 18,
            fontWeight: FontWeight.w300,
            widgets: [
              DeptContainer(section: section[0], deptName: Dept, yr: yr[3]),
              DeptContainer(section: section[1], deptName: Dept, yr: yr[3]),
            ],
          ),
        ]);
  }
}

class KExpansionTile extends StatefulWidget {
  final String deptName;
  final List<Widget> widgets;
  final String yr;
  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;

  KExpansionTile(
      {@required this.deptName,
      this.yr,
      this.widgets,
      this.fontSize,
      this.fontColor,
      this.fontWeight});

  @override
  _KExpansionTileState createState() => _KExpansionTileState();
}

class _KExpansionTileState extends State<KExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        backgroundColor: Theme.of(context).backgroundColor,
        collapsedBackgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          widget.deptName,
          style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryIconTheme.color),
        ),
        children: widget.widgets);
  }
}

class DeptContainer extends StatelessWidget {
  final String deptName;
  final String yr;
  final String section;

  DeptContainer(
      {@required this.deptName, @required this.yr, @required this.section});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StudentList(deptName: deptName, yr: yr, section: section),
          ),
        );
      },
      child: Container(
        height: 40,
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(spreadRadius: 0.2, blurRadius: 7, color: Colors.grey)
            ]),
        child: Text(
          section,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800]),
        ),
      ),
    );
  }
}

class Gridview extends StatelessWidget {
  final String text;
  final String image;
  final Function onPressed;

  Gridview({this.text, this.image, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: TextButton(
              onPressed: onPressed,
              child: Container(
                width: 70,
                height: 70,
                child: Image.asset(image),
              ),
            ),
          ),
          Container(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).accentIconTheme.color),
            ),
          )
        ],
      ),
    );
  }
}
