import 'dart:ui';
import 'package:notes_app/auth/register.dart';
import 'package:notes_app/component/authIcon.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../HomePage.dart';
import '../component/TextBuilding.dart';
import '../component/customTextFormField.dart';
import '../component/customTextPassword.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  State<Login> createState() => _Login();
}
class _Login extends State<Login>{
  GlobalKey <FormState> formState = GlobalKey();
  bool isLoading = false;
  bool isLoadingGoogle = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser == null){
      return;
    }
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
    );
  }
  Future<String> _resetPasswordAndReturnDescription(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "Check your email, and set your password again";
    } catch (e) {
      return "Error resetting password: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Container(
        //   decoration: BoxDecoration(
        //     color: Colors.grey[200],
        //     borderRadius: BorderRadius.all(Radius.circular(10)),
        //   ),
        //   child: Icon(Icons.arrow_back_ios_new),
        // ),
      ),
      body: (isLoading ==true || isLoadingGoogle ==true )? Center(
        child: CircularProgressIndicator(),
      ):Form(
        key: formState,
        child: ListView(
          children: [
            AuthIcon(ImagePath: 'assets/login.PNG'),
            ListTile(
              title:
              TextBuilding(value: "Login",fontSize: 40,fontWeight: FontWeight.bold,applyPadding: false,),
              subtitle:
              TextBuilding(value: "Login to continue using the app",fontSize: 20,color:Colors.deepOrange,fontFamily:"Dancing Script",applyPadding: false),
            ),
            TextBuilding(value: "Email *", fontSize: 20,),
            CustomTextFormField(
              icon: Icon(Icons.email_outlined),
              hintText:"Enter your email ...",
              mycontroller: email,),
            TextBuilding(value: "Password *",fontSize: 20,),
            CustomTextPassword(
              obscureText: _obscureText,
              mycontroller: password,hintText: "Enter your password ...",
              preIcon: Icon(Icons.password_outlined),
              sufIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBuilding(value: "* is required",fontSize: 10),
                TextButton(
                  onPressed: () async {
                    String dialogDesc = email.text == ""
                        ? "Please specify Your Email"
                        : await _resetPasswordAndReturnDescription(email.text);

                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      transitionAnimationDuration: Duration(seconds: 1),
                      animType: AnimType.bottomSlide,
                      desc: dialogDesc,
                    )..show();

                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.of(context).pop();
                    });
                  },
                  child: TextBuilding(value: "Forget Password?", fontSize: 15),
                )
              ],
            ),
          MaterialButton(
        onPressed: () async {
          if (formState.currentState != null && formState.currentState!.validate()) {
            isLoading =true;
            setState(() {

            });
            String? text;
            DialogType? dialogType;
            AnimType? animType;

            try {
              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email.text,
                password: password.text,
              );
              text = "Successful login";
              dialogType = DialogType.success;
              animType = AnimType.leftSlide;
            } on FirebaseAuthException catch (e) {
              switch (e.code) {
                case 'user-not-found':
                  print("No user found for that email.");
                  text = "No user found for that email.";
                  break;
                case 'wrong-password':
                  print("Wrong password provided for that user.");
                  text = "Wrong password provided for that user.";
                  break;
                case 'invalid-credential':
                  print("The supplied auth credential is incorrect or malformed.");
                  text = "The supplied auth credential is incorrect or malformed.";
                  break;
                default:
                  print("FirebaseAuthException: ${e.code}");
                  text = "Login failed! Please try again.";
              }
              dialogType = DialogType.error;
              animType = AnimType.leftSlide;
            } catch (e) {
              print("Exception: $e");
              text = "An unexpected error occurred: $e";
              dialogType = DialogType.error;
              animType = AnimType.leftSlide;
            }
            isLoading =false ;
            setState(() {

            });
            if (dialogType == DialogType.error){
              AwesomeDialog(
                  context: context,
                  dialogType: dialogType!,
                  transitionAnimationDuration: Duration(seconds: 1),
                  animType: animType!,
                  desc: text
              ).show();
              Future.delayed(Duration(seconds: 4), () {
                Navigator.of(context).pop();
              });
            }
            else {
              if (!FirebaseAuth.instance.currentUser!.emailVerified){
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.info,
                  animType: AnimType.rightSlide,
                  desc: 'Please go to your email and confirm your identity!',
                )..show();
                Future.delayed(Duration(seconds: 4), () {
                  Navigator.of(context).pop();
                });
              }
              else {
                AwesomeDialog(
                    context: context,
                    dialogType: dialogType!,
                    transitionAnimationDuration: Duration(seconds: 1),
                    animType: animType!,
                    desc: text
                ).show();
                Future.delayed(Duration(seconds: 4), () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                  );
                });
              }
            }
          } else {
            print("Not Valid!");
          }
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextBuilding(value: "Login", color: Colors.white, fontSize: 20, applyPadding: false),
            ],
          ),
        ),
      ),
          Container(
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Divider(
                    color: CupertinoColors.black,
                    thickness: 1,
                  )),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextBuilding(value: "Or Login with",applyPadding: false,fontSize: 15,),
                  ),
                  Expanded(
                      child: Divider(
                        color: CupertinoColors.black,
                        thickness: 1,
                      )),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround ,
                children: [
                  IconButton(onPressed: () {

                  },icon: Icon(Icons.facebook,size: 50,),),
                  IconButton(onPressed: () {
                    isLoadingGoogle =true;
                    setState(() {

                    });
                    signInWithGoogle();
                    isLoadingGoogle =false;
                    setState(() {

                    });
                  }, icon: SvgPicture.asset(
                    'assets/google_Icon.svg',
                    width: 50,
                    height: 50,
                  ),),
                  IconButton(onPressed: () {

                  }, icon: Icon(Icons.apple,size: 50,)),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextBuilding(value: "Don't have an account?",fontSize: 15,applyPadding: false,),
                  TextButton(onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Register()));
                  }, child: TextBuilding(value: "Register",fontSize: 15,applyPadding: false,))
                ],
              ),
            ),
          ],
        ),),
    );
  }

}