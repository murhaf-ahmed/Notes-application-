import 'package:notes_app/component/validation.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Validation val = Validation();
  late TextEditingController mycontroller;
  late Icon? icon;
  late String hintText;
  late int? maxlines;
  CustomTextFormField({
    required this.mycontroller,
    this.icon,
    this.maxlines = 1,
    required this.hintText,
  });
  @override
  Widget build(BuildContext context) {
    return  Padding(padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
      child:TextFormField(
        maxLines: maxlines,
      validator: (value) {
        if(hintText.contains("name")){
          return val.validateUsername(value!);
        }
        else if (hintText.contains("email")){
          return val.validateEmail(value!);
        }
        if(hintText.contains("Category")){
          return val.validateCategory(value!);
        }
        if(hintText.contains("Note")){
          return val.validateNote(value!);
        }
      },
    controller: mycontroller,
    decoration: InputDecoration(
    prefixIcon: icon,
    hintText: hintText,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    )),
    ),
    );
  }
}
