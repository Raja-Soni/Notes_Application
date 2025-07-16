import 'package:flutter/material.dart';

class CustomText extends StatelessWidget{
  final String text;
  final Color textColor;
  final double textSize;
  final FontWeight textBoldness;

  const CustomText({
    super.key,
    required this.text,
    this.textColor=Colors.white,
    this.textSize=20.0,
    this.textBoldness=FontWeight.normal,
    });
  @override
  Widget build(BuildContext context){
    return Text(
      text,
      style:
        TextStyle(color: textColor, fontSize: textSize, fontWeight: textBoldness),
    );
  }
}