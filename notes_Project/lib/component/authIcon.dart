import 'package:flutter/cupertino.dart';

class AuthIcon extends StatelessWidget {
  late String ImagePath ;
  AuthIcon({
    required this.ImagePath,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(ImagePath, fit: BoxFit.fill, width: 100, height: 100,),
        ),
      ),
    );
  }
}









