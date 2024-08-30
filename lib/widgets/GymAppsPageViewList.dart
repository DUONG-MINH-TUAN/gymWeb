import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:gymApps/constant/colours.dart';

const bodyStyle = TextStyle(fontSize: 19.0, color: Colors.black54);
const pageDecoration = PageDecoration(
  bodyAlignment: Alignment.bottomCenter,
  bodyFlex: 1,
  bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0), // Reduced bottom padding
  bodyTextStyle: bodyStyle,
  imageAlignment: Alignment.center,
  imageFlex: 3,
  imagePadding: EdgeInsets.zero,
  pageColor: Colors.white, // Changed from LabColors.defaultCyan to white
  titlePadding: EdgeInsets.only(top: 0, bottom: 5.0),
  titleTextStyle: TextStyle(
      fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.black87), // Changed from white to black87
);

final List<String> titles = [
  "Make Use of Your Spare Time",
  "Track Your Workouts",
  "Get Personalized Training Plans",
  "Join Our Fitness Community"
];

final List<Widget> bodies = [
  const Wrap(children: [
    Text("Make use of your spare time ", style: bodyStyle),
    Icon(
      Icons.access_alarms_outlined,
      color: Colors.black54, // Changed from LabColors.white to Colors.black54
    ),
    Text(" to keep fit and stay healthy", style: bodyStyle),
  ]),
  const Wrap(children: [
    Text("Track your workouts ", style: bodyStyle),
    Icon(
      Icons.fitness_center,
      color: Colors.black54, // Changed from LabColors.white to Colors.black54
    ),
    Text(" and monitor your progress", style: bodyStyle),
  ]),
  const Wrap(children: [
    Text("Get personalized training plans ", style: bodyStyle),
    Icon(
      Icons.schedule,
      color: Colors.black54, // Changed from LabColors.white to Colors.black54
    ),
    Text(" tailored to your fitness goals", style: bodyStyle),
  ]),
  const Wrap(children: [
    Text("Join our fitness community ", style: bodyStyle),
    Icon(
      Icons.group,
      color: Colors.black54, // Changed from LabColors.white to Colors.black54
    ),
    Text(" and stay motivated together", style: bodyStyle),
  ]),
];

final images = [
  "swimming.png",
  "running.png",
  "banner_slider_2.png",
  "banner_slider_3.png"
];

final pageViewElements = List<Map<String, dynamic>>.generate(
    images.length,
    (index) => {
          'title': titles[index],
          'body': bodies[index],
          'image': images[index],
        });

Widget buildImage(String assetName, [double width = 420]) {
  return Image.asset('lib/assets/image/$assetName',
      width: width, fit: BoxFit.contain);
}

List<PageViewModel> pageViewModels = pageViewElements
    .map((item) => PageViewModel(
          title: item['title']!,
          bodyWidget: item['body']!,
          image: buildImage(item['image']),
          decoration: pageDecoration,
        ))
    .toList();
