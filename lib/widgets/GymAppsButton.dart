import 'package:flutter/material.dart';
import 'package:gymApps/constant/colours.dart';

class GradientButton extends StatelessWidget {
  final Function onTap;
  final double height;
  final double borderRadius;
  final String text;

  const GradientButton({
    super.key,
    required this.onTap,
    this.height = 50,
    this.borderRadius = 10,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: this.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(this.borderRadius),
            gradient: LinearGradient(colors: [
              LabColors.defaultCyan,
              Color.fromRGBO(143, 148, 251, .6),
            ])
        ),
        child: Center(
          child: Text(this.text,
            style:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        ),
      )
    );
  }
}