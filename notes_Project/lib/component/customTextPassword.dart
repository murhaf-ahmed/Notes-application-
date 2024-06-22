import 'package:notes_app/component/validation.dart';
import 'package:flutter/material.dart';

class CustomTextPassword extends StatelessWidget {
  final Validation val = Validation();
  late TextEditingController mycontroller;
  late Icon preIcon;
  late IconButton sufIcon;
  late String? hintText;
  late bool obscureText;
  final String? Function()? getPassword;

  CustomTextPassword({
    required this.mycontroller,
    required this.sufIcon,
    required this.preIcon,
    required this.hintText,
    required this.obscureText,
    this.getPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        validator: (value) {
          if (hintText!.contains("Confirm")) {
            return val.validateConfirmPassword(value, getPassword!());
          } else {
            return val.validatePassword(value);
          }
        },
        controller: mycontroller,
        onSaved: (newValue) {},
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: preIcon,
          suffixIcon: sufIcon,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
