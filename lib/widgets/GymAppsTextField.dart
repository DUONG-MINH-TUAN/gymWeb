import "package:flutter/material.dart";
import 'package:animate_do/animate_do.dart';

import '../constant/colours.dart';

enum FadeInType { up, down, left, right }

class FadeInTextField extends StatefulWidget {
  final FadeInType fadeInType;
  final Duration duration;
  final TextEditingController controller;
  final String? hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode focusNode;

  FadeInTextField({
    super.key,
    required this.fadeInType,
    required this.controller,
    this.duration = const Duration(seconds: 1),
    this.hintText,
    this.prefixIcon = const Icon(Icons.help_outline),
    this.suffixIcon = const Icon(Icons.help_outline),
    required this.labelText,
    FocusNode? focusNode, // Make focusNode optional
  }) : focusNode = focusNode ?? FocusNode();

  @override
  State<FadeInTextField> createState() => FadeInTextFieldState();
}

class FadeInTextFieldState extends State<FadeInTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    Widget textField = TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Default border color
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: LabColors.defaultCyan,width: 2), // Border color when focused
          ),
          isDense: false,
          hintText: widget.hintText ?? widget.labelText,
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon,
          labelStyle: TextStyle(
              color: widget.focusNode.hasFocus ? LabColors.defaultCyan : Colors.black)
      ),
    );

    switch (widget.fadeInType) {
      case FadeInType.up:
        return FadeInUp(child: textField, duration: widget.duration);
      case FadeInType.down:
        return FadeInDown(child: textField, duration: widget.duration);
      case FadeInType.left:
        return FadeInLeft(child: textField, duration: widget.duration);
      case FadeInType.right:
        return FadeInRight(child: textField, duration: widget.duration);
      default:
        return textField;
    }
  }
}

class ObscureFadeInTextField extends FadeInTextField {
  final bool obscureText;
  ObscureFadeInTextField({
    super.key,
    required FadeInType fadeInType,
    required TextEditingController controller,
    Duration duration = const Duration(seconds: 1),
    String? hintText,
    Widget? prefixIcon = const Icon(Icons.help_outline),
    Widget? suffixIcon = const Icon(Icons.help_outline),
    required String labelText,
    this.obscureText = false,
  }) : super(
    fadeInType: fadeInType,
    controller: controller,
    duration: duration,
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    labelText: labelText,
  );

  @override
  State<ObscureFadeInTextField> createState() => ObscureFadeInTextFieldState();
}

class ObscureFadeInTextFieldState extends State<ObscureFadeInTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    Widget textField = TextField(
      controller: widget.controller,
        focusNode: widget.focusNode,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Default border color
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: LabColors.defaultCyan,width: 2), // Border color when focused
          ),
          isDense: false,
          hintText: widget.hintText ?? widget.labelText,
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        labelStyle: TextStyle(
            color: widget.focusNode.hasFocus ? LabColors.defaultCyan : Colors.black))
    );

    switch (widget.fadeInType) {
      case FadeInType.up:
        return FadeInUp(child: textField, duration: widget.duration);
      case FadeInType.down:
        return FadeInDown(child: textField, duration: widget.duration);
      case FadeInType.left:
        return FadeInLeft(child: textField, duration: widget.duration);
      case FadeInType.right:
        return FadeInRight(child: textField, duration: widget.duration);
      default:
        return textField;
    }
  }
}
