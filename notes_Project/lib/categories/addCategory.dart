import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HomePage.dart';
import '../component/customTextFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});
  State<AddCategory> createState() => _AddCategory();
}
class _AddCategory extends State<AddCategory>{
  GlobalKey <FormState>formState = GlobalKey();
  TextEditingController category = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  Future<void> addCategory() {
    return categories
        .add({
      'category': category.text, 'User_id' :FirebaseAuth.instance.currentUser!.uid
    })
        .then((value) => {
      print("Category Added"),

    })
        .catchError((error) => print("Failed to add category: $error"));
  }
  @override
  void dispose() {
    category.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading:  IconButton(onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
            );
          }, icon: Icon(Icons.arrow_back)),
          elevation: double.maxFinite,
          shape: OutlineInputBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(0))),
          title: Text("Add Category"),
        ),
        body: Form(
          key: formState,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              CustomTextFormField(
                mycontroller: category,
                hintText: "Add your Category ...",
              ),
              Container(
                padding: EdgeInsets.only(right: 20),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 50,
                        width: 100,
                        color: Colors.deepOrange[200],
                          child: TextButton(child: Text("Add",style: TextStyle(fontSize: 20),),onPressed: () {
                            if(formState.currentState!.validate()){
                              addCategory();
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                transitionAnimationDuration: Duration(seconds: 1),
                                animType: AnimType.bottomSlide,
                                desc: "Category ${category.text} is added",
                              )..show();
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => AddCategory()),
                                      (route) => false,
                                );
                              });
                            }
                            else{
                              print("Not Valid");
                            }
                          },),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

}