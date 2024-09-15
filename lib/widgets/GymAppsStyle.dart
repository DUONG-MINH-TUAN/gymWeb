import 'package:flutter/material.dart';

class GymAppsStyle{
  static ButtonStyle noneEffectButtonStyle = ButtonStyle(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      minimumSize: WidgetStateProperty.all(Size(50, 30)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
}

