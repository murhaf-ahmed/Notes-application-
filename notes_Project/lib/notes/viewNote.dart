import 'package:notes_app/HomePage.dart';
import 'package:notes_app/auth/login.dart';
import 'package:notes_app/notes/updateNote.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'addNote.dart';

class ViewNote extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  const ViewNote({super.key,  this.categoryId,  this.categoryName});
  State<ViewNote> createState() => _ViewNote();
}
class _ViewNote extends State<ViewNote>{
  late CollectionReference notes;
  late bool isLoading =true;
  List data =[];


  @override
  void initState() {
    notes = FirebaseFirestore.instance.collection('categories').doc(widget.categoryId).collection('notes');
    getData();
    super.initState();
  }
  getData() async{
    QuerySnapshot querySnapshot = await notes.get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {
    });
    }

  Future<void> deleteNote(String noteId) async{
    return await notes
        .doc(noteId)
        .delete()
        .then((value) => print("note Deleted"))
        .catchError((error) => print("Failed to delete note: $error"));
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
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AddNote(categoryId: widget.categoryId,categoryName: widget.categoryName,)),
              (route) => false,
            );
          }, icon: Icon(Icons.add),),
        ),
      ),
      appBar: AppBar(
          leading:  IconButton(onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
            );
            },
              icon: Icon(Icons.arrow_back)),
          elevation: double.maxFinite,
          shape: OutlineInputBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(0))),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
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
          ], title: Text("${widget.categoryName} Notes",style: TextStyle(fontSize: 15),)
      ),
      body: (isLoading ==true) ? Center(
        child: CircularProgressIndicator(),
      ):
      Container(
        padding: EdgeInsets.all(20),
        child:
        SingleChildScrollView(
            child: Column(
                children: [
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,crossAxisSpacing: 5,mainAxisExtent: 400),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return InkWell(
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
                        MaterialPageRoute(builder: (context) => UpdateNote(
                          note: data[index],
                          old_name: data[index]['note'],
                          categoryId: widget.categoryId,
                          categoryName: widget.categoryName,)
                        ),
                        (route) => false,
                      );
                    },
                    btnCancelOnPress: () {
                      deleteNote(data[index].id);
                      if (data[index]['imageNote']!="") {
                        FirebaseStorage.instance.refFromURL(data[index]['imageNote']).delete();
                      }
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => ViewNote(categoryId: widget.categoryId,categoryName: widget.categoryName,)),
                      (route) => false,
                      );
                    },
                  )..show();
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 1),
                          height: 1,
                          color: Colors.deepOrange,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: 100,height: 100,
                          child:  ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: (data[index]['imageNote']=="")?Image(image: AssetImage("assets/note.png"),fit: BoxFit.cover,)
                                : Image(image: NetworkImage(data[index]['imageNote']),fit: BoxFit.cover,),
                          ),
                        ),
                        Text(
                          data[index]['note'],
                          style: TextStyle(fontSize: 16),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        )]
            )),
      ),
    );
  }
}
