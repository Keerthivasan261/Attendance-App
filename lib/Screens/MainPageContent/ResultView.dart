import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultView extends StatefulWidget {
  static const id = "ResultView";

  final String registerNumber;

  ResultView({this.registerNumber});

  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  DatabaseReference _result;
  final FirebaseDatabase referenceDatabase = FirebaseDatabase.instance;

  @override
  void initState() {
    // TODO: implement initState
    _result = referenceDatabase
        .reference()
        .child('Results')
        .child(widget.registerNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: InteractiveViewer(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.93,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0.3,
                      blurRadius: 6,
                      color: Colors.grey,
                      offset: Offset(1, 3))
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(children: [
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 8),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("Images/kiotlogo.png"))),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              "Knowledge Institute of Technology",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              "Kakapalayam,Salem",
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.red[400],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "Register Number : ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700)),
                              TextSpan(text: "${widget.registerNumber}",style: TextStyle(color: Colors.red[700],fontSize: 18,fontWeight: FontWeight.w700))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.red[400]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                height: 25,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  'Subject Code',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    'Subject Name',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                            ),
                            Container(
                                alignment: Alignment.center,
                                height: 25,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Text(
                                  'Grade',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                )),
                          ],
                        ),
                      ),
                    ),
                    FirebaseAnimatedList(
                      shrinkWrap: true,
                      query: _result,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom:3),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red[50]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    height: 25,
                                    width:
                                        MediaQuery.of(context).size.width * 0.25,
                                    child: Text(snapshot.value['SubjectCode'])),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Container(
                                      alignment: Alignment.center,
                                      width:
                                          MediaQuery.of(context).size.width * 0.4,
                                      child: Text(
                                        snapshot.value['SubjectName'],
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    height: 25,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Text(snapshot.value['Grade'])),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
