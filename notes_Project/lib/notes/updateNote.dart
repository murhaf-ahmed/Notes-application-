import 'package:notes_app/notes/viewNote.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../component/customTextFormField.dart';

class UpdateNote extends StatefulWidget {
  final String? categoryId;
  final QueryDocumentSnapshot note ;
  final String? old_name;
  final String? categoryName;

  const UpdateNote({
    Key? key,
    required this.note, required this.old_name, this.categoryId, this.categoryName,
  }) : super(key: key);

  State<UpdateNote> createState() => _UpdateNote();
}
class _UpdateNote extends State<UpdateNote>{
  TextEditingController note = TextEditingController();
  GlobalKey <FormState>formState = GlobalKey();

  Future<void> updateNote(String notePara) {
    CollectionReference notes = FirebaseFirestore.instance.collection('categories').doc(widget.categoryId).collection('notes');
    return notes
        .doc(widget.note.id)
        .update({'note': notePara})
        .then((value) => print("Note Updated"))
        .catchError((error) => print("Failed to update Note: $error"));
  }
  @override
  void initState() {
    note.text = widget.old_name!;
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
          leading: IconButton(onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => ViewNote(categoryId: widget.categoryId,categoryName: widget.categoryName,)),
                  (route) => false,
            );
          }, icon: Icon(Icons.arrow_back)),
          elevation: double.maxFinite,
          shape: OutlineInputBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(0))),
          title: Text(" Update Note"),
        ),
        body: Form(
          key: formState,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              CustomTextFormField(
                mycontroller: note,
                hintText: "Update your Note ...",
                maxlines: 5,
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
                            updateNote(note.text);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              transitionAnimationDuration: Duration(seconds: 1),
                              animType: AnimType.bottomSlide,
                              desc: "Note is Updated",
                            )..show();
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => ViewNote(categoryId: widget.categoryId,categoryName: widget.categoryName,)),
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