import 'package:notes_app/HomePage.dart';
import 'package:notes_app/auth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatefulWidget{
  const MyApp({super.key});
  State<MyApp> createState() =>_MyAppState();
}
class _MyAppState extends State<MyApp>{

  @override
  void initState() {
   FirebaseAuth.instance.authStateChanges().listen((User? user) {
     if (user == null) {
        print("============== User is currently signed out ==============");
     }
     else{
       print("============== User is currently signed in ==============");
     }
   });
    super.initState();
  }

  bool checkInstance() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: (checkInstance() && FirebaseAuth.instance.currentUser!.emailVerified) ? HomePage() : Login(),
    );
  }
}