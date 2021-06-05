import 'package:attendance_app/MyTheme.dart';
import 'package:attendance_app/Screens/MainPageContent/DeptPage.dart';
import 'package:attendance_app/Screens/MainPageContent/ResultView.dart';
import 'package:attendance_app/Screens/RegistrationScreen.dart';
import 'package:captcha_view/captcha.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  static const id = "ResultPage";

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  DateTime currentDate = DateTime.now();
  static String captcha;
  TextEditingController captchaController = TextEditingController();
  TextEditingController registerNumberController = TextEditingController();
  TextEditingController adRegisterNumberController = TextEditingController();
  TextEditingController adSubjectCodeController = TextEditingController();
  TextEditingController adSubjectNameController = TextEditingController();
  TextEditingController adGradeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2030));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  Widget buildDialog(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Register Number",
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                ),
                KTextField(
                  icons: MdiIcons.account,
                  obscureText: false,
                  hintText: "Register Number",
                  controller: adRegisterNumberController,
                ),
                Divider(
                  thickness: 1.5,
                  indent: 10,
                  endIndent: 10,
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Subject Code",
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                ),
                KTextField(
                  icons: MdiIcons.textShort,
                  obscureText: false,
                  hintText: "Eg: CS8351",
                  controller: adSubjectCodeController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Subject Name",
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Consumer<MyTheme>(
                    builder: (context, theme, child) => Container(
                      height: 55,
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
                      child: TextFormField(
                        maxLines: 3,
                        controller: adSubjectNameController,
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          prefixIcon: Icon(MdiIcons.bookOpenVariant),
                          isDense: true,
                          hintText: "Eg: Programming in C",
                          hintStyle: TextStyle(color: Colors.grey[400],),
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Grade",
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                ),
                KTextField(
                  icons: MdiIcons.progressQuestion,
                  obscureText: false,
                  hintText: "Eg: A+",
                  controller: adGradeController,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: MaterialButton(
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        checkUpload();
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
    super.initState();
    captchaGenerator();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyTheme>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          provider.isStudent
              ? SizedBox(
                  width: 0,
                )
              : PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: TextButton(
                          onPressed: () {
                            showDialog(context: context, builder: buildDialog);
                          },
                          child: Container(
                            child: Text(
                              "Upload result",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentColor),
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
              color: Theme.of(context).primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SingleChildScrollView(
                child: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50, top: 60),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.18,
                          width: 150,
                          child: Image(
                            image: AssetImage(
                              "Images/kiotlogo.png",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        KTextField(
                          icons: MdiIcons.accountGroupOutline,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          hintText: "Register number",
                          controller: registerNumberController,
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        color: Colors.grey,
                                        blurRadius: 10,
                                        offset: Offset(1, 3))
                                  ]),
                              child: ListTile(
                                leading: Icon(MdiIcons.lock),
                                title: Text(
                                  "${currentDate.day.toString()}-${currentDate.month.toString()}-${currentDate.year.toString()}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[800]),
                                ),
                                trailing: Icon(MdiIcons.calendar),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(MdiIcons.rotateRight,
                                  color:
                                      Theme.of(context).accentIconTheme.color),
                              onPressed: () {
                                captchaGenerator();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Captcha(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: Captcha.rainbowColors),
                                    borderRadius: BorderRadius.circular(5)),
                                height: 50,
                                width: 220,
                                text: captcha,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Consumer<MyTheme>(
                            builder: (context, theme, child) => Container(
                              height: 50,
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
                              child: TextField(
                                controller: captchaController,
                                keyboardType: TextInputType.text,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(MdiIcons.text),
                                  hintText: "Enter Captcha",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: RawMaterialButton(
                            onPressed: () {
                              checkResult();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            fillColor: Theme.of(context).primaryColor,
                            child: Text(
                              "Get Result",
                              style: TextStyle(
                                  color: Theme.of(context).backgroundColor),
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
        ],
      ),
    );
  }

  String captchaGenerator() {
    setState(() {
      captcha = Captcha.generateText(length: 6);
    });
  }

  checkResult() {
    if (registerNumberController.text.length != 12) {
      {
        displayToastMessage(context, "Invalid Register number");
      }
    } else if (captchaController.text != captcha) {
      displayToastMessage(context, "Invalid captcha");
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultView(
                    registerNumber: registerNumberController.text,
                  )));
      captchaController.clear();
    }
  }

  checkUpload() {
    if (adRegisterNumberController.text.length != 12) {
      displayToastMessage(context, "Invalid Register number");
    } else if (adSubjectCodeController.text.isEmpty) {
      displayToastMessage(context, "Enter Subject code");
    } else if (adSubjectNameController.text.isEmpty) {
      displayToastMessage(context, "Enter Subject Name");
    } else if (adGradeController.text.isEmpty) {
      displayToastMessage(context, "Enter Grade");
    } else {
      Map userData = {
        "SubjectName": adSubjectNameController.text,
        "SubjectCode": adSubjectCodeController.text,
        "Grade": adGradeController.text,
      };
      final referenceDatabase = FirebaseDatabase.instance;
      final newStud = referenceDatabase.reference();

      var check = newStud
          .child("Results")
          .child(adRegisterNumberController.text)
          .child(adSubjectCodeController.text)
          .set(userData)
          .asStream();
      if (check != null) {
        displayToastMessage(
            context, "Result for ${adSubjectNameController.text} added");
      }
      adSubjectCodeController.clear();
      adSubjectNameController.clear();
      adGradeController.clear();
    }
  }
}
