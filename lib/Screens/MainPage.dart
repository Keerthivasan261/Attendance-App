import 'package:attendance_app/Constants/ExtractWidgets.dart';
import 'package:attendance_app/MyTheme.dart';
import 'package:attendance_app/Screens/MainPageContent/DeptPage.dart';
import 'package:attendance_app/Screens/LoginScreen.dart';
import 'package:attendance_app/Screens/MainPageContent/KiotNews.dart';
import 'package:attendance_app/Screens/MainPageContent/ResultPage.dart';
import 'package:attendance_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  static const id = "MainPage";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String pos;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRef.child(_auth.currentUser.uid).once().then(
            (DataSnapshot snapshot){
              print(pos);
              pos = snapshot.value['Position'];
        });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyTheme>(context);
    if(pos=="Student"){
      provider.changeToStudent();
    }
    else if(pos=="Teacher"){
      provider.changeToStaff();
    }
    print(provider.isStudent);
    return Scaffold(
      drawer: Drawer(
        elevation: 14,
        child: SafeArea(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Image(
                        image: AssetImage("Images/unknownuser.jpg"),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Text(
                          "${_auth.currentUser.email}",
                          style: GoogleFonts.courgette(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Divider(
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Switch(
                      value: provider.isLightTheme,
                      onChanged: (change) {
                        provider.ChangeTheme();
                      },
                      inactiveTrackColor: Theme.of(context).primaryColor,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    Container(
                        width: 200,
                        child: Text(
                          "${provider.isLightTheme ? "Light Theme" : "Dark Theme"}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, DeptPage.id);
                    },
                    child: Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).accentColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                  child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Are you sure want to sign out?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          await _auth.signOut();
                                          Navigator.pushNamedAndRemoveUntil(context,
                                              LoginScreen.id, (route) => false);
                                        },
                                        child: Text(
                                          "Sign out",
                                          style: TextStyle(
                                              fontSize: 19, color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(fontSize: 15,color: Colors.grey),
                                        ),
                                      ),
                                    ])
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  child: Text(
                    "Sign out",
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).accentColor),
                  ),
                ),
              )),
            ],
          ),
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
                padding: EdgeInsets.fromLTRB(10, 20, 10, 8),
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
                child: GridView.count(
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: 3,
                  children: [
                    Gridview(
                      text: "Kiot News",
                      image: "Images/kiotlogo.png",
                      onPressed: () {
                        Navigator.pushNamed(context, KiotNews.id);
                      },
                    ),
                    Gridview(
                      text: "Results",
                      image: "Images/result.png",
                      onPressed: () {
                        Navigator.pushNamed(context, ResultPage.id);
                      },
                    ),
                    Gridview(
                      text: "Search",
                      image: "Images/Search.png",
                      onPressed: () {
                        Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "Internals",
                      image: "Images/Internals.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "Attendance Taker",
                      image: "Images/attendance.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "Upcoming contests",
                      image: "Images/contest.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "Syllabus",
                      image: "Images/syllabus.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "Placement",
                      image: "Images/placement.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "TimeTable",
                      image: "Images/timetable.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "complex prog. questions",
                      image: "Images/complexprog.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "Exam Info.",
                      image: "Images/exams.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "Performance",
                      image: "Images/performance.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "Ranking",
                      image: "Images/ranking.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "Awards",
                      image: "Images/awards.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "Skillrack Points",
                      image: "Images/skillrack.jpg",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                    Gridview(
                      text: "About Us",
                      image: "Images/aboutus.png",
                      onPressed: () {
                        //Navigator.pushNamed(context, DeptPage.id);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
