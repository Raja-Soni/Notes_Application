import 'package:flutter/material.dart';
import 'package:notes_app/custom_widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color focusColor;
  final Color splashColor;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final String buttonText;
  final Color textColor;
  final FontWeight textBoldness;
  final VoidCallback callback;
  final String? givenHeroTag;

  const CustomButton({
    super.key,
    this.backgroundColor = Colors.brown,
    this.focusColor = Colors.yellow,
    this.splashColor = Colors.green,
    this.borderRadius = 20.0,
    this.borderWidth = 0,
    this.borderColor = Colors.black,
    required this.buttonText,
    required this.callback,
    this.textColor = Colors.white,
    this.textBoldness = FontWeight.bold,
    this.givenHeroTag,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 80,
      child: FloatingActionButton(
        heroTag: givenHeroTag,
        onPressed: () {
          callback();
        },
        backgroundColor: backgroundColor,
        splashColor: splashColor,
        focusColor: focusColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(width: borderWidth, color: borderColor),
        ),
        child: CustomText(
          text: buttonText,
          textColor: textColor,
          textBoldness: textBoldness,
        ),
      ),
    );
  }
}
