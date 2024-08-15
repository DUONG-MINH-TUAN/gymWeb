import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:gymApps/constant/colours.dart';

const bodyStyle = TextStyle(fontSize: 19.0, color: Colors.white);
const pageDecoration = PageDecoration(
  bodyAlignment: Alignment.bottomCenter,
  bodyFlex: 1,
  bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
  bodyTextStyle: bodyStyle,
  imageAlignment: Alignment.center,
  imageFlex: 3,
  imagePadding: EdgeInsets.zero,
  pageColor: LabColors.defaultCyan,
  titlePadding: EdgeInsets.only(top: 0, bottom: 5.0),
  titleTextStyle: TextStyle(
      fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white),
);

final List<String> titles= [
  "Introduction Page 1",
  "Introduction Page 2",
  "Introduction Page 3",
  "Introduction Page 4"
];

final List<Widget> bodies= [
  const Wrap(children: [
    Text("Make use of your spare time ", style: bodyStyle),
    Icon(
      Icons.access_alarms_outlined,
      color: LabColors.white,
    ),
    Text(" to keep fit and stay healthy", style: bodyStyle),
  ]),
  const Wrap(
    children: [Text("Discover the features of the app in this second page.")],
  ),
  const Wrap(
    children: [Text("Get tips on using the app effectively on this third page.")],
  ),
  const Wrap(
    children: [Text("You're ready to start using the app! Let's get going.")],
  )
];

final images= [
  "swimming.png",
  "running.png",
  "banner_slider_2.png",
  "banner_slider_3.png"
];

final pageViewElements = List<Map<String, dynamic>>.generate(images.length, (index) => {
  'title': titles[index],
  'body': bodies[index],
  'image': images[index],
});