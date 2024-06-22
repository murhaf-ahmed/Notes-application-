import 'dart:io';
import 'package:notes_app/notes/viewNote.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../component/customTextFormField.dart';
import 'package:path/path.dart' as path;

class AddNote extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  const AddNote({super.key, this.categoryId, this.categoryName});
  State<AddNote> createState() => _AddNote();
}
class _AddNote extends State<AddNote>{
  File? file;
  String? url ;
  late var refStorage;
  String? imageName;

  GlobalKey <FormState>formState = GlobalKey();
  TextEditingController note = TextEditingController();

  Future<void> addNote() async {
    try {
      CollectionReference notes = FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .collection('notes');
      print ("-----------------------------------------------------------------");

      if (imageName!=null && file!=null){
        refStorage = FirebaseStorage.instance.ref("images").child(imageName!);
        await refStorage.putFile(file!);
        url = await refStorage.getDownloadURL();
      }
      else {
        url = "";
      }
      print ("-----------------------------------------------------------------");
      print(url);
      await notes.add({
        'imageNote': url,
        'note': note.text,
      });

      print("Note Added");
    } catch (error) {
      print("Failed to add Note: $error");
    }
  }

  Future<void> addImage () async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageGallery = await picker.pickImage(source: ImageSource.gallery);
    if (imageGallery != null){
      file = File(imageGallery!.path);
      imageName = path.basename(imageGallery!.path);
    }
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading:  IconButton(onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => ViewNote(categoryId: widget.categoryId,categoryName: widget.categoryName,)),
              (route) => false,
            );
          }, icon: Icon(Icons.arrow_back)),
          elevation: double.maxFinite,
          shape: OutlineInputBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(0))),
          title: Text("Add Note"),
        ),
        body: Form(
          key: formState,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              CustomTextFormField(
                mycontroller: note,
                hintText: "Add your Note ...",
                maxlines: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 5,bottom: 50),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(onPressed: () {
                            addImage();
                          },child: Text("Choose an image for your note",style: TextStyle(color: Colors.deepOrange)))
                        ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(file!=null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              file!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
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
                            addNote();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              transitionAnimationDuration: Duration(seconds: 1),
                              animType: AnimType.bottomSlide,
                              desc: "Note ${note.text} is added",
                            )..show();
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => AddNote(categoryName: widget.categoryName,categoryId: widget.categoryId,)),
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