import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gymApps/constant/colours.dart';
import 'package:animate_do/animate_do.dart';
import 'signUp.dart';

class logInPage extends StatefulWidget {
  const logInPage({super.key});

  @override
  State<logInPage> createState() => logInPageState();
}

class logInPageState extends State<logInPage> {
  late TextEditingController email;
  late TextEditingController password;
  late GoogleAuthProvider authProvider;
  late PageController pageController;
  late Timer timer;

  int currentPage = 0;
  bool passwordVisible = false;
  var imageLists = ["lib/assets/image/banner_slider_0.png",
                    "lib/assets/image/banner_slider_1.png",
  "lib/assets/image/banner_slider_2.png","lib/assets/image/banner_slider_3.png"];

  @override
  void initState() {
    super.initState();
    authProvider = GoogleAuthProvider();
    email = TextEditingController();
    password = TextEditingController();
    pageController = PageController(initialPage: currentPage);
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      print(currentPage);
      setState(() {
        currentPage = ++currentPage % imageLists.length;
      });
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    timer.cancel();
    pageController.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void googleLogin() async {
    late UserCredential userCredential;
    try {
      if (kIsWeb) {
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(authProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return buildLogInSectionWithSlider(constraints);
        } else {
          return Center(child: buildSimpleLogInSection(constraints));
        }
      }),
    );
  }

  Widget buildSimpleLogInSection(BoxConstraints constraints) {
    const paddingSymmetric = EdgeInsets.symmetric(horizontal: 40);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: paddingSymmetric,
        height: constraints.maxHeight,
        width: 450,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -10, // Position at the top
              left: 0, // Position at the left
              right: 0,
              child: FadeInDown(
                duration: Duration(milliseconds: 2000),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'CrossFit',
                    style: TextStyle(
                        fontSize: 75,
                        color: LabColors.defaultCyan,
                        fontFamily: 'Jomhuaria'),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 80, // Position at the top
                left: 0, // Position at the left
                right: 0,
                child: displayTextFieldsAndButton(constraints))
          ],
        ),
      ),
    );
  }

  Widget buildLogInSectionWithSlider(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: constraints.maxWidth - 450,
          height: constraints.maxHeight,
          child: PageView.builder(
        controller: pageController,
        itemCount: imageLists.length,
        itemBuilder: (context, index) {
      return Image.asset(imageLists[index],
                fit: BoxFit.fitHeight);}
          ),
        ),
        buildSimpleLogInSection(constraints)
      ],
    );
  }

  Widget displayTextFieldsAndButton(BoxConstraints constraints) {
    return Container(
        child: Column(children: [
      FadeInLeft(
        duration: Duration(milliseconds: 2000),
        child: TextField(
          controller: email,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: false,
            hintText: "What is your registered email ?",
            labelText: 'Email',
            prefixIcon: Icon(Icons.help_outline),
          ),
        ),
      ),
      SizedBox(height: 15),
      FadeInRight(
        duration: Duration(milliseconds: 2000),
        child: TextFormField(
          controller: password,
          obscureText: passwordVisible,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: false,
              hintText: 'Password',
              labelText: 'Your password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  })),
        ),
      ),
      SizedBox(height: 5),
      FadeInLeft(
          duration: Duration(milliseconds: 2000),
          child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(60, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => signUpPage(
                              title: 'Sign Up',
                            )));
              },
              child: Text(
                "New To This App ? Let's Sign Up",
                style: TextStyle(
                    color: LabColors.defaultCyan,
                    fontFamily: 'Jomhuaria',
                    fontSize: 25),
              ))),
      FadeInRight(
          duration: Duration(milliseconds: 2000),
          child: TextButton(
            onPressed: () {
              // showEmailDialog(context);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(60, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "Forgot Password ?",
              style: TextStyle(
                  color: LabColors.defaultCyan,
                  height: 1,
                  fontFamily: 'Jomhuaria',
                  fontSize: 25),
            ),
          )),
      SizedBox(height: 10),
      FadeInUp(
        duration: Duration(milliseconds: 2000),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(), // Circular shape
            elevation: 0, // No shadow, // Padding can be adjusted
          ),
          onPressed: googleLogin, // login
          child: Image.asset(
            'lib/assets/icon/Google.png',
            width: 40,
            height: 40,
          ),
        ),
      ),
      //login button
      SizedBox(height: 20),
      FadeInDown(
        duration: Duration(milliseconds: 2000),
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
      Image.asset(
        'lib/assets/image/swimming.jpg',
        height: constraints.maxHeight * 0.275,
      )
    ]));
  }
}
