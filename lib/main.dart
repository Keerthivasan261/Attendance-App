import 'package:attendance_app/Screens/MainPageContent/DeptPage.dart';
import 'package:attendance_app/Screens/LoginScreen.dart';
import 'package:attendance_app/MyTheme.dart';
import 'package:attendance_app/Screens/MainPage.dart';
import 'package:attendance_app/Screens/MainPageContent/KiotNews.dart';
import 'package:attendance_app/Screens/MainPageContent/ResultPage.dart';
import 'package:attendance_app/Screens/MainPageContent/ResultView.dart';
import 'package:attendance_app/Screens/RegistrationScreen.dart';
import 'package:attendance_app/Screens/MainPageContent/StudentList.dart';
import 'package:attendance_app/ThemeData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

DatabaseReference userRef =
FirebaseDatabase.instance.reference().child('Users');
FirebaseAuth _auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => MyTheme(),
      child: Consumer<MyTheme>(
        builder: (context, theme, child) =>
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              themeMode: theme.isLightTheme ? ThemeMode.light : ThemeMode.dark,
              initialRoute:
              _auth.currentUser != null ? MainPage.id : LoginScreen.id,
              routes: {
                KiotNews.id:(context)=> KiotNews(),
                ResultView.id: (context) => ResultView(),
                ResultPage.id: (context) => ResultPage(),
                MainPage.id: (context) => MainPage(),
                StudentList.id: (context) => StudentList(),
                LoginScreen.id: (context) => LoginScreen(),
                RegistrationScreen.id: (context) => RegistrationScreen(),
                DeptPage.id: (context) => DeptPage(),
              },
            ),
      ),
    );
  }
}
