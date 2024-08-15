import 'dart:async';
import 'package:gymApps/main.dart';
import 'package:flutter/material.dart';
import 'package:gymApps/view/signUp.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gymApps/constant/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gymApps/widgets/GymAppsStyle.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:gymApps/widgets/GymAppsPageViewList.dart';
import 'package:gymApps/widgets/GymAppsTextField.dart';

class logInPage extends StatefulWidget {
  const logInPage({super.key});

  @override
  State<logInPage> createState() => logInPageState();
}

class logInPageState extends State<logInPage> {
  late TextEditingController email;
  late TextEditingController password;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late GoogleAuthProvider authProvider;
  PageController? pageController;
  Timer? timer;
  late Size deviceSize;
  late GlobalKey<IntroductionScreenState> introKey;

  int currentPage = 0;
  bool passwordVisible = false;
  late List<PageViewModel> pageViewModels;

  PageDecoration pageDecoration = PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    titlePadding: EdgeInsets.only(top: 8.0, bottom: 12.0),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );

  @override
  void initState() {
    super.initState();
    authProvider = GoogleAuthProvider();
    email = TextEditingController();
    password = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    introKey = GlobalKey<IntroductionScreenState>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void initializePageController() {
  //   pageController = PageController(initialPage: currentPage);
  //   timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
  //     // print(currentPage);
  //     setState(() {
  //       currentPage = ++currentPage % pageViewModels.length;
  //     });
  //     pageController?.animateToPage(
  //       currentPage,
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeIn,
  //     );
  //   });
  // }

  // void disposePageController() {
  //   timer?.cancel();
  //   pageController?.dispose();
  //   pageController = null;
  //   print("Timer cancelled");
  //   print("PageController disposed");
  // }

  Widget buildImage(String assetName, [double width = 420]) {
    return Image.asset('lib/assets/image/$assetName',
        width: width, fit: BoxFit.contain);
  }

  void googleLogin() async {
    late UserCredential userCredential;
    try {
      if (kIsWeb) {
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(authProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        // Create a GoogleAuthProvider credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with Google credentials
        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
      }

      if (userCredential.user?.uid != null) {
        print('Login successfully');
      }
    } catch (e) {
      print(e);
    }
  }

  String validateInput(String email, String password) {
    if (email.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email';
    } else if (password.isEmpty) {
      return "Password field is empty";
    } else {
      return 'Validated';
    }
  }

  void logIn() async {
    var isValidated = validateInput(email.text, password.text);
    if (isValidated == 'Validated') {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.text, password: password.text);
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found' || e.code == 'invalid-email') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else {
          errorMessage =
              'An unexpected error occurred. Please try again later.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(
          seconds: 3,
        ),
        content: Text(isValidated),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    pageViewModels = pageViewElements.map((item) => PageViewModel(
      title: item['title']!,
      bodyWidget: item['body']!,
      image: buildImage(item['image']),
      decoration: pageDecoration,
    )).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: OrientationBuilder(
          builder: (context, orientation) {
            // if (orientation == Orientation.landscape) {
            //   if (pageController == null) {
            //     initializePageController();
            //   }
            // } else {
            //   if (pageController != null) {
            //     disposePageController();
            //   }
            // }
            return Center(
                child: (deviceSize.width >= 750)
                    ? buildLogInSectionWithSlider()
                    : buildSimpleLogInSection(false),
            );
          },
        ),
      ),
    );
  }

  Widget buildLogInSectionWithSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            color: Colors.orangeAccent,
            width: deviceSize.width * 0.7,
            height: deviceSize.height,
            child:
                // PageView.builder(
                //     controller: pageController,
                //     itemCount: imageLists.length,
                //     itemBuilder: (context, index) {
                //       return Image.asset(imageLists[index], fit: BoxFit.contain);
                //     }),
                IntroductionScreen(
              key: introKey,
              globalBackgroundColor: LabColors.defaultCyan,
              allowImplicitScrolling: true,
              autoScrollDuration: 10000,
              infiniteAutoScroll: true,
              pages: pageViewModels,
              showSkipButton: false,
              showDoneButton: false,
              skipOrBackFlex: 0,
              nextFlex: 0,
              showBackButton: true,
              //rtl: true, // Display as right-to-left
              back: const Icon(Icons.arrow_left_sharp,
                  color: LabColors.defaultCyan, size: 50),
              next: const Icon(Icons.arrow_right_sharp,
                  color: LabColors.defaultCyan, size: 50),
              curve: Curves.easeInOutQuart,
              controlsMargin:
                  const EdgeInsets.only(bottom: 50, right: 30, left: 30),
              controlsPadding: kIsWeb
                  ? const EdgeInsets.all(5.0)
                  : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
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
                color: LabColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            )),
        buildSimpleLogInSection(true)
      ],
    );
  }

  Widget buildSimpleLogInSection(bool isLandscape) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: deviceSize.height,
        width: isLandscape ? deviceSize.width * 0.299 : deviceSize.width,
        child: Column(
          children: <Widget>[displayRichTitle(), displayTextFieldsAndButton()],
        ),
      ),
    );
  }

  Widget displayTextFieldsAndButton() {
    return Column(children: [
      FadeInTextField(
        fadeInType: FadeInType.up,
        duration: Duration(milliseconds: 1200),
        controller: email,
        labelText: 'Email',
        hintText: 'What is your registered email ?',
        prefixIcon: Icon(Icons.help_outline),
      ),
      SizedBox(height: 25),
      ObscureFadeInTextField(
        fadeInType: FadeInType.up,
        duration: Duration(milliseconds: 1600),
        controller: password,
        obscureText: passwordVisible,
        labelText: 'Password',
        hintText: 'Your password',
        prefixIcon: Icon(Icons.lock_outline),
        suffixIcon: IconButton(
            icon:
                Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            }),
      ),
      SizedBox(height: 15),
      FadeInUp(
          duration: Duration(milliseconds: 1600),
          child: TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                // Tắt hiệu ứng hover và click
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                // Bỏ padding
                minimumSize: WidgetStateProperty.all(Size(50, 30)),
                // Kích thước tối thiểu
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => signUpPage()));
              },
              child: Text(
                "New User ? Let's Sign Up",
                style: TextStyle(
                    color: LabColors.defaultCyan,
                    fontFamily: 'Jomhuaria',
                    fontSize: 25),
              ))),
      FadeInUp(
          duration: Duration(milliseconds: 1800),
          child: TextButton(
            onPressed: () {
              // showEmailDialog(context);
            },
            style: GymAppsStyle.noneEffectButtonStyle,
            child: Text(
              "Forgot Password ?",
              style: TextStyle(
                  color: LabColors.defaultCyan,
                  height: 1,
                  fontFamily: 'Jomhuaria',
                  fontSize: 25),
            ),
          )),
      SizedBox(height: 20),
      FadeInSocialLogInButtons(),
      //login button
      SizedBox(height: 30),
      FadeInUp(
        duration: Duration(milliseconds: 2200),
        child: InkWell(
          onTap: logIn,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  LabColors.defaultCyan,
                  Color.fromRGBO(143, 148, 251, .6),
                ])),
            child: Center(
              child: Text(
                "Login",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 35),
    ]);
  }

  Widget FadeInSocialLogInButtons() {
    return FadeInUp(
      duration: Duration(milliseconds: 2000),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              // Tắt hiệu ứng hover và click
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              // Bỏ padding
              minimumSize: WidgetStateProperty.all(Size(50, 30)),
              // Kích thước tối thiểu
              tapTargetSize: MaterialTapTargetSize
                  .shrinkWrap, // Tắt hiệu ứng ripple mở rộng
            ),
            onPressed: googleLogin, // login
            child: Container(
              color: Colors.white,
              width: 50, // Đặt chiều rộng mong muốn
              height: 50, // Đặt chiều cao mong muốn
              child: Image.asset(
                'lib/assets/icon/google.png',
                // Đường dẫn đến hình ảnh của bạn
                fit: BoxFit.contain, // Hoặc BoxFit.cover
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              // Tắt hiệu ứng hover và click
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              // Bỏ padding
              minimumSize: WidgetStateProperty.all(Size(50, 30)),
              // Kích thước tối thiểu
              tapTargetSize: MaterialTapTargetSize
                  .shrinkWrap, // Tắt hiệu ứng ripple mở rộng
            ),
            onPressed: googleLogin, // login
            child: Container(
              color: Colors.white,
              width: 45, // Đặt chiều rộng mong muốn
              height: 45, // Đặt chiều cao mong muốn
              child: Image.asset(
                'lib/assets/icon/x.png',
                // Đường dẫn đến hình ảnh của bạn
                fit: BoxFit.contain, // Hoặc BoxFit.cover
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              // Tắt hiệu ứng hover và click
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              // Bỏ padding
              minimumSize: WidgetStateProperty.all(Size(50, 30)),
              // Kích thước tối thiểu
              tapTargetSize: MaterialTapTargetSize
                  .shrinkWrap, // Tắt hiệu ứng ripple mở rộng
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            }, // login
            child: Container(
              color: Colors.white,
              width: 50, // Đặt chiều rộng mong muốn
              height: 50, // Đặt chiều cao mong muốn
              child: Image.asset(
                'lib/assets/icon/home.png',
                // Đường dẫn đến hình ảnh của bạn
                fit: BoxFit.contain, // Hoặc BoxFit.cover
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayRichTitle() {
    const fontWeight = FontWeight.w400;
    return FadeInUp(
      duration: Duration(milliseconds: 1000),
      child: Container(
          // color: LabColors.socialTwitter,
          width: double.infinity,
          padding: EdgeInsets.only(top: 20, bottom: 30),

          child: FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "Crossfit ",
                  style: TextStyle(
                    color: LabColors.gradientStart,
                    fontFamily: 'Oswald',
                    fontWeight: fontWeight,
                  )),
              TextSpan(
                text: "|",
                style: TextStyle(
                    color: LabColors.gradientMid,
                    fontFamily: 'Oswald',
                    fontWeight: fontWeight),
              ),
              TextSpan(
                  text: " Log In",
                  style: TextStyle(
                      color: LabColors.gradientEnd,
                      fontFamily: 'Oswald',
                      fontWeight: fontWeight))
            ])),
          )),
    );
  }
}
