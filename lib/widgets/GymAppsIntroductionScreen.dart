import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:GymApps/constant/colours.dart';

class GymAppsIntroductionScreen extends StatelessWidget {
  final GlobalKey<IntroductionScreenState> introKey;

  const GymAppsIntroductionScreen({Key? key, required this.introKey}) : super(key: key);

  static const bodyStyle = TextStyle(fontSize: 19.0, color: Colors.black54);
  static const pageDecoration = PageDecoration(
    bodyAlignment: Alignment.bottomCenter,
    bodyFlex: 1,
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    bodyTextStyle: bodyStyle,
    imageAlignment: Alignment.center,
    imageFlex: 3,
    imagePadding: EdgeInsets.zero,
    pageColor: Colors.white,
    titlePadding: EdgeInsets.only(top: 0, bottom: 5.0),
    titleTextStyle: TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.black87),
  );

  static final List<PageViewModel> pageViewModels = _buildPageViewModels();

  static List<PageViewModel> _buildPageViewModels() {
    final List<String> titles = [
      "Maximize Your Potential",
      "Achieve Peak Performance",
      "Customize Your Fitness Journey",
      "Strength in Numbers"
    ];

    final List<Widget> bodies = [
      _buildBodyWidget("Make use of your spare time ", Icons.access_alarms_outlined, " to keep fit and stay healthy"),
      _buildBodyWidget("Track your workouts ", Icons.fitness_center, " and monitor your progress"),
      _buildBodyWidget("Get personalized training plans ", Icons.schedule, " tailored to your fitness goals"),
      _buildBodyWidget("Join our fitness community ", Icons.group, " and stay motivated together"),
    ];

    final images = [
      "swimming.png",
      "running.png",
      "banner_slider_2.png",
      "banner_slider_3.png"
    ];

    return List.generate(
      images.length,
      (index) => PageViewModel(
        title: titles[index],
        bodyWidget: bodies[index],
        image: _buildImage(images[index]),
        decoration: pageDecoration,
      ),
    );
  }

  static Widget _buildBodyWidget(String prefix, IconData icon, String suffix) {
    return Wrap(children: [
      Text(prefix, style: bodyStyle),
      Icon(icon, color: Colors.black54),
      Text(suffix, style: bodyStyle),
    ]);
  }

  static Widget _buildImage(String assetName, [double width = 420]) {
    return Image.asset('lib/assets/image/$assetName',
        width: width, fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 10000,
      infiniteAutoScroll: true,
      pages: pageViewModels,
      showSkipButton: false,
      showDoneButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      back: const Icon(Icons.arrow_left_sharp,
          color: LabColors.defaultCyan, size: 50),
      next: const Icon(Icons.arrow_right_sharp,
          color: LabColors.defaultCyan, size: 50),
      curve: Curves.easeInOutQuart,
      controlsMargin: const EdgeInsets.only(bottom: 40, right: 30, left: 30),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.black54,
        activeSize: Size(22.0, 10.0),
        activeColor: LabColors.defaultCyan,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
