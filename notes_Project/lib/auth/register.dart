import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HomePage.dart';
import '../component/TextBuilding.dart';
import '../component/authIcon.dart';
import '../component/customTextFormField.dart';
import '../component/customTextPassword.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  bool _obscureTextPass = true;
  bool _obscureTextConfPass = true;

  @override
  void _togglePasswordVisibility() {
    setState(() {
      _obscureTextPass = !_obscureTextPass;
    });
  }

  void _toggleConfPasswordVisibility() {
    setState(() {
      _obscureTextConfPass = !_obscureTextConfPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                    (route) => false,
              );            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
      ),
      body: isLoading ==true ? Center(child: CircularProgressIndicator()):Form(
        key: formState,
        child: ListView(
          children: [
            AuthIcon(ImagePath: 'assets/register.PNG'),
            ListTile(
              title:
              TextBuilding(value: "Register",fontSize: 40,fontWeight: FontWeight.bold,applyPadding: false,),
              subtitle:
              TextBuilding(value: "Enter your personal information",fontSize: 20,color:Colors.deepOrange,fontFamily:"Dancing Script",applyPadding: false),
            ),
            TextBuilding(value: "Username *"),
            CustomTextFormField(
              icon: Icon(Icons.supervised_user_circle_outlined),
              hintText: "Enter your name ...",
              mycontroller: username,
            ),
            TextBuilding(value: "Email *", fontSize: 20),
            CustomTextFormField(
              icon: Icon(Icons.email_outlined),
              hintText: "Enter your email ...",
              mycontroller: email,
            ),
            TextBuilding(value: "Password *", fontSize: 20),
            CustomTextPassword(
              obscureText: _obscureTextPass,
              mycontroller: password,
              hintText: "Enter your password ...",
              preIcon: Icon(Icons.password_outlined),
              sufIcon: IconButton(
                icon: Icon(
                  _obscureTextPass ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            TextBuilding(value: "Confirm Password *", fontSize: 20),
            CustomTextPassword(
              obscureText: _obscureTextConfPass,
              mycontroller: confPassword,
              hintText: "Enter Confirm password ...",
              preIcon: Icon(Icons.password_outlined),
              sufIcon: IconButton(
                icon: Icon(
                  _obscureTextConfPass ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _toggleConfPasswordVisibility,
              ),
              getPassword: () => password.text,
            ),
            MaterialButton(
              onPressed: () async {
                if (formState.currentState != null && formState.currentState!.validate()) {
                  isLoading =true ;
                  setState(() {

                  });
                  String ? text;
                  DialogType? dialogType;
                  AnimType? animType;
                  try {
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    text = "An account has been created";
                    dialogType = DialogType.success;
                    animType=AnimType.leftSlide;

                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      text = "The password provided is too weak.";
                    } else if (e.code == 'email-already-in-use') {
                      text = "The account already exists for that email.";
                    }
                    dialogType = DialogType.error;
                    animType=AnimType.leftSlide;

                  } catch (e) {
                    print(e);
                  }
                  isLoading = false;
                  setState(() {

                  });
                  AwesomeDialog(
                    context: context,
                    dialogType: dialogType!,
                    transitionAnimationDuration: Duration(seconds: 1),
                    animType: animType!,
                    title: (dialogType == DialogType.error)? "" : text,
                    desc: (dialogType == DialogType.error)? text : "please verify your email ...",
                  )..show();
                  Future.delayed(Duration(seconds: 4), () {
                    if (dialogType == DialogType.success) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                            (route) => false,
                      );
                    }
                    else{
                      Navigator.of(context).pop();
                    }
                  });
                }
                else {
                  print("Not Valid!");
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: TextBuilding(
                        value: "Register Now!",
                        fontSize: 20,
                        color: Colors.white,
                        applyPadding: false,
                      ),
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
