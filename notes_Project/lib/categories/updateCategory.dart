import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HomePage.dart';
import '../component/customTextFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCategory extends StatefulWidget {
  final QueryDocumentSnapshot cat ;
  final String? old_name;
  const UpdateCategory({
    Key? key,
    required this.cat, required this.old_name,
  }) : super(key: key);

  State<UpdateCategory> createState() => _UpdateCategory();
}
class _UpdateCategory extends State<UpdateCategory>{

  TextEditingController category = TextEditingController();
  GlobalKey <FormState>formState = GlobalKey();
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  Future<void> updateCategory(String categoryPara) {
    return categories
        .doc(widget.cat.id)
        .update({'category': categoryPara})
        .then((value) => print("category Updated"))
        .catchError((error) => print("Failed to update category: $error"));
  }
  @override
  void initState() {
    category.text = widget.old_name!;
    super.initState();
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
          leading: IconButton(onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
            );
          }, icon: Icon(Icons.arrow_back)),
          elevation: double.maxFinite,
          shape: OutlineInputBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(0))),
          title: Text(" Update Category"),
        ),
        body: Form(
          key: formState,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              CustomTextFormField(
                mycontroller: category,
                hintText: "Update your Category ...",
              ),
              Container(
                padding: EdgeInsets.only(right: 20),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 50,
                        width: 100,
                        color: Colors.deepOrange[200],
                          child: TextButton(child: Text("Update",style: TextStyle(fontSize: 20),),onPressed: () {
                            if(formState.currentState!.validate()){
                              updateCategory(category.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                transitionAnimationDuration: Duration(seconds: 1),
                                animType: AnimType.bottomSlide,
                                desc: "Category is Updated",
                              )..show();
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => HomePage()),
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