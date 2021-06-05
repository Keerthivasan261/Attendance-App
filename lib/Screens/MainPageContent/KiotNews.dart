import 'package:attendance_app/MyTheme.dart';
import 'package:attendance_app/Screens/MainPageContent/DeptPage.dart';
import 'package:attendance_app/Screens/RegistrationScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class KiotNews extends StatefulWidget {
  static const id = "Kiot News";

  @override
  _KiotNewsState createState() => _KiotNewsState();
}

class _KiotNewsState extends State<KiotNews> {
  DatabaseReference _news;
  final FirebaseDatabase referenceDatabase = FirebaseDatabase.instance;
  TextEditingController headLineController = TextEditingController();
  TextEditingController deptController = TextEditingController();
  TextEditingController briefNewsController = TextEditingController();

  Widget buildDialog(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Choose Department",
                    style: TextStyle(
                        fontSize: 16, color: Theme
                        .of(context)
                        .primaryColor),
                  ),
                ),
                KTextField(
                  icons: MdiIcons.bookOpenBlankVariant,
                  obscureText: false,
                  hintText: "Eg: CSE or COMMON NEWS",
                  controller: deptController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "HeadLine News",
                    style: TextStyle(
                        fontSize: 16, color: Theme
                        .of(context)
                        .primaryColor),
                  ),
                ),
                KTextField(
                  icons: MdiIcons.textShort,
                  obscureText: false,
                  hintText: "Type headline news ...",
                  controller: headLineController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Brief News",
                    style: TextStyle(
                        fontSize: 16, color: Theme
                        .of(context)
                        .primaryColor),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Consumer<MyTheme>(
                    builder: (context, theme, child) =>
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 1,
                                    color: theme.isLightTheme
                                        ? Colors.grey
                                        : Colors.grey[700],
                                    blurRadius: 10,
                                    offset: Offset(1, 3))
                              ]),
                          child: TextFormField(
                            maxLines: 1000,
                            controller: briefNewsController,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              prefixIcon: Icon(MdiIcons.newspaper),
                              hintText: "Type Brief News ...",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Theme
                                        .of(context)
                                        .primaryColor),
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: MaterialButton(
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      color: Theme
                          .of(context)
                          .primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        checkNewsUpload();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _news = referenceDatabase.reference().child("News");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyTheme>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        actions: [
          provider.isStudent
              ? SizedBox(
            width: 0,
          )
              : PopupMenuButton(
            itemBuilder: (BuildContext context) =>
            [
              PopupMenuItem(
                child: TextButton(
                    onPressed: () {
                      showDialog(context: context, builder: buildDialog);
                    },
                    child: Container(
                      child: Text(
                        "Upload News",
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme
                                .of(context)
                                .accentColor),
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: KMyClipper(),
            child: Container(
              height: 250,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 70, 10, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(top: 20),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0.5,
                          blurRadius: 7,
                          color: Colors.grey,
                        )
                      ],
                      color: Theme
                          .of(context)
                          .backgroundColor,
                    ),
                    child: Column(
                      children: [
                        kFirebaseList(
                          news: _news,
                          dept: "CSE",
                        ),
                        kFirebaseList(
                          news: _news,
                          dept: "ECE",
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkNewsUpload() {
    if (headLineController.text.isEmpty) {
      displayToastMessage(context, "Enter Headline News");
    } else if (briefNewsController.text.isEmpty) {
      displayToastMessage(context, "Enter Brief News");
    } else {
      Map userData = {
        "BriefNews": briefNewsController.text,
        "HeadLines": headLineController.text,
      };
      final referenceDatabase = FirebaseDatabase.instance;
      final news = referenceDatabase.reference();

      var check = news
          .child("News")
          .child(deptController.text)
          .push()
          .set(userData)
          .asStream();
      if (check != null) {
        displayToastMessage(context, "News uploaded");
      }
      briefNewsController.clear();
      headLineController.clear();
      deptController.clear();
    }
  }
}

class kFirebaseList extends StatelessWidget {
  final DatabaseReference news;
  final String dept;

  kFirebaseList({this.news, this.dept});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dept,
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
        ),
        FirebaseAnimatedList(
            shrinkWrap: true,
            query: news.child(dept),
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Container(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Text(
                                          snapshot.value['HeadLines'],
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 19),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 10),
                                        child: Text(
                                          snapshot.value['BriefNews'] != null
                                              ? snapshot.value['BriefNews']
                                              : " ", style: TextStyle(
                                          fontSize: 16,),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "${snapshot.value['HeadLines']}",
                      style: TextStyle(fontSize: 18),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[700],
                              spreadRadius: 0.2,
                              blurRadius: 8)
                        ]),
                  ),
                ),
              );
            }),
        Divider(
          thickness: 1,
          color: Colors.grey,
          indent: 20,
          endIndent: 20,
        )
      ],
    );
  }
}
