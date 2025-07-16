import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final TextEditingController? inputController;
  final TextInputType? keyboardType;
  final Color? cursorColor;
  final Color? inputTextColor;
  final double? inputTextSize;
  final FontWeight? inputTextBoldness;
  final String labelText;
  final Color? labelTextColor;
  final double? labelTextSize;
  final FontWeight? labelTextBoldness;
  final String hintText;
  final Color? hintTextColor;
  final double? hintTextSize;
  final FontWeight? hintTextBoldness;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final double enabledBorderRadius;
  final double enabledBorderWidth;
  final Color enabledBorderColor;
  final double focusedBorderRadius;
  final double focusedBorderWidth;
  final Color focusedBorderColor;
  final int? maxLinesAllowed;
  final FloatingLabelBehavior labelBehaviour;

  const CustomTextField({
  super.key,
  required this.inputController,
  this.keyboardType = TextInputType.text,
  this.cursorColor = Colors.white,
  this.inputTextColor = Colors.white,
  this.inputTextSize = 20.0,
  this.inputTextBoldness = FontWeight.normal,
  required this.labelText,
  this.labelTextColor=Colors.white,
  this.labelTextSize=20.0,
  this.labelTextBoldness=FontWeight.normal,
  required this.hintText,
  this.hintTextColor=Colors.white,
  this.hintTextSize=20.0,
  this.hintTextBoldness=FontWeight.normal,
  this.borderRadius=10.0,
  this.borderColor=Colors.black,
  this.borderWidth=1,
  this.enabledBorderRadius=10.0,
  this.enabledBorderColor=Colors.white,
  this.enabledBorderWidth=1,
  this.focusedBorderRadius=10.0,
  this.focusedBorderColor=Colors.green,
  this.focusedBorderWidth=1,
  this.maxLinesAllowed=7,
  this.labelBehaviour=FloatingLabelBehavior.always,
  });


  @override
  Widget build(BuildContext context){
    return TextField(
      maxLines: maxLinesAllowed,
      controller: inputController,
      keyboardType:keyboardType,
      cursorColor:cursorColor,
      style: TextStyle(color:inputTextColor , fontSize:inputTextSize , fontWeight:inputTextBoldness),
      decoration: InputDecoration(
        label: Text(labelText, style: TextStyle(color: labelTextColor, fontSize:labelTextSize , fontWeight:labelTextBoldness),
        ),floatingLabelBehavior: labelBehaviour,
        hint: Text(hintText, style: TextStyle(color: hintTextColor, fontSize: hintTextSize , fontWeight: hintTextBoldness),),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: borderWidth,
              color: borderColor,
            )
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(enabledBorderRadius),
            borderSide: BorderSide(
            width: enabledBorderWidth,
            color: enabledBorderColor,
            )
          ),
          focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(focusedBorderRadius),
          borderSide: BorderSide(
          width: focusedBorderWidth,
          color: focusedBorderColor,
          )
          )
      ),
    );
  }
}