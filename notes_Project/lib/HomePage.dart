import 'package:notes_app/categories/addCategory.dart';
import 'package:notes_app/auth/login.dart';
import 'package:notes_app/notes/viewNote.dart';
import 'package:notes_app/categories/updateCategory.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  State<HomePage> createState() => _HomePage();
}
class _HomePage extends State<HomePage>{
  late bool isLoading =true;
  List data =[];
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');


  @override
  void initState() {
    getData();
    super.initState();
  }
   getData() async{
   QuerySnapshot querySnapshot = await categories.get();
   for (int i=0 ; i<querySnapshot.size;i++){
     if (querySnapshot.docs[i]['User_id'] == FirebaseAuth.instance.currentUser!.uid){
       data.add(querySnapshot.docs[i]);
     }
   }
   isLoading = false;
   setState(() {
   });
  }

  Future<void> deleteCategory(String catId) async{
    return await categories
        .doc(catId)
        .delete()
        .then((value) => print("Category Deleted"))
        .catchError((error) => print("Failed to delete Category: $error"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: Colors.deepOrange[50],
          width: 75,
          height: 75,
          child: IconButton(iconSize: 50,color: Colors.deepOrange,onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddCategory()),
            );
          }, icon: Icon(Icons.add),),
          ),
        ),
      appBar: AppBar(
          leading: Icon(Icons.home_filled),
          elevation: double.maxFinite,
          shape: OutlineInputBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(0))),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // No background color
                  elevation: MaterialStateProperty.all<double>(0), // No elevation
                ),
                onPressed: () async{
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                    (route) => false,
              );
            }, child: Row(
              children: [
                Icon(Icons.exit_to_app,color: Colors.deepOrange),
                Text("Log out"),
                  ]
                )),
                  ], title: Text("My Sections")
              ),
              body: (isLoading ==true) ? Center(
                child: CircularProgressIndicator(),
              ):Container(
                padding: EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 15,mainAxisExtent: 150),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => ViewNote(categoryId: data[index].id, categoryName: data[index]['category']))
                        );
                      },
                      onLongPress: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.info,
                  transitionAnimationDuration: Duration(seconds: 1),
                  animType: AnimType.bottomSlide,
                  desc: "Choose what type of operations you want?",
                  btnCancelText: "Delete",
                  btnOkText: "Update",
                  btnOkOnPress: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => UpdateCategory(cat: data[index], old_name: data[index]['category'],)),
                          (route) => false,
                    );
                  },
                  btnCancelOnPress: () {
                    deleteCategory(data[index].id);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                )..show();
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child:
                ListView(
                  children: [
                    Container(
                      child:
                      Image(image: AssetImage("assets/category.png"),
                          height: 100,
                          fit: BoxFit.cover),
                      height: 100,
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 1,
                      color: Colors.deepOrange,
                    ),
                    Text(data[index]['category'], style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
            );
          }
          // },
        ),
      ),
    );
  }
}
