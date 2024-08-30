import 'logIn.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gymApps/constant/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymApps/widgets/GymAppsStyle.dart';
import 'package:gymApps/widgets/GymAppsButton.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gymApps/widgets/GymAppsTextField.dart';
import 'package:gymApps/widgets/GymAppsPageViewList.dart';
import 'package:introduction_screen/introduction_screen.dart';


class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpState();
}

class _signUpState extends State<signUpPage> {
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController passwordConfirm;
  late PageController pageController;
  late GlobalKey<IntroductionScreenState> introKey;
  late List<PageViewModel> pageViewModels;
  late Size deviceSize;

  PageDecoration pageDecoration = PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    titlePadding: EdgeInsets.only(top: 8.0, bottom: 12.0),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );

  void signUp() async {
    var isValidated = validateInput(username.text, email.text, password.text);

    if (isValidated == 'Validated') {
      //thiếu phần thêm username vào database
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
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

  String validateInput(String username, String email, String password) {
    if (username.isEmpty) {
      return 'Please enter your username';
    }
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    if (password.isEmpty) {
      return "Password field is empty";
    }
    return 'Validated';
  }

  // tự động chạy khi tạo page này
  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    passwordConfirm = TextEditingController();
    introKey = GlobalKey<IntroductionScreenState>();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    passwordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: OrientationBuilder(
          builder: (context, orientation) {
            return Center(
                child: (deviceSize.width >= 750)
                    ? buildSignUpSectionWithSlider()
                    : buildSimpleSignUpSection(false),
            );
          },
        ),
      ),
    );
  }

  Widget buildSignUpSectionWithSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            color: Colors.orangeAccent,
            width: deviceSize.width * 0.7,
            height: deviceSize.height,
            child: GymAppsIntroductionScreen(introKey: introKey),
        ),
        buildSimpleSignUpSection(true)
      ],
    );
  }

  Widget buildSimpleSignUpSection(bool isLandscape) {
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

  Widget displayRichTitle() {
    const fontWeight = FontWeight.w400;
    return FadeInUp(
      duration: Duration(milliseconds: 1000),
      child: Container(
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
                  text: " Register",
                  style: TextStyle(
                      color: LabColors.gradientEnd,
                      fontFamily: 'Oswald',
                      fontWeight: fontWeight))
            ])),
          )),
    );
  }

  Widget buildImage(String assetName, [double width = 420]) {
    return Image.asset('lib/assets/image/$assetName',
        width: width, fit: BoxFit.contain);
  }

  Widget displayTextFieldsAndButton() {
    return Column(
      children: [
        FadeInTextField(
          fadeInType: FadeInType.up,
          duration: Duration(milliseconds: 1200),
          controller: username,
          labelText: 'Username',
          hintText: 'Username for your new account',
          prefixIcon: Icon(Icons.person_outline),
        ),
        SizedBox(height: 15),
        FadeInTextField(
          fadeInType: FadeInType.up,
          duration: Duration(milliseconds: 1400),
          controller: email,
          labelText: 'Email',
          hintText: 'Your email used for register new account',
          prefixIcon: Icon(Icons.email_outlined),
        ),
        SizedBox(height: 15),
        ObscureFadeInTextField(
          fadeInType: FadeInType.up,
          duration: Duration(milliseconds: 1600),
          controller: password,
          initialObscureText: true,
          labelText: 'Password',
          hintText: 'Please enter your password',
          prefixIcon: Icon(Icons.password_outlined),
        ),
        SizedBox(height: 15),
        FadeInTextField(
          fadeInType: FadeInType.up,
          duration: Duration(milliseconds: 1800),
          controller: passwordConfirm,
          labelText: 'Confirm Password',
          hintText: 'Please re-enter your password',
          prefixIcon: Icon(Icons.lock_outline),
        ),
        SizedBox(height: 15),
        FadeInUp(
            duration: Duration(milliseconds: 1900),
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    logInPage()));
              },
              style: GymAppsStyle.noneEffectButtonStyle,
              child: Text(
                "Have An Account Already ? Let's Log In",
                style: TextStyle(
                    color: LabColors.defaultCyan,
                    height: 1,
                    fontFamily: 'Jomhuaria',
                    fontSize: 25),
              ),
            )),
        SizedBox(height: 10),
        FadeInUp(
            duration: Duration(milliseconds: 2150),child: GradientButton(onTap: signUp, text: "Sign Up"))
      ],
    );
  }
}
