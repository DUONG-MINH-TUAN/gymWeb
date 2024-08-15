import 'logIn.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gymApps/constant/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymApps/widgets/GymAppsStyle.dart';
import 'package:gymApps/widgets/GymAppsButton.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gymApps/widgets/GymAppsTextField.dart';


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
    const paddingSymmetric = EdgeInsets.symmetric(horizontal: 40);
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            color: Colors.white,
            // padding: paddingSymmetric,
            height: constraints.maxHeight,
            width: 450,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -10, // Position at the top
                  left: 0, // Position at the left
                  right: 0,
                  child: FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        child: Text(
                          'CrossFit | Register',
                          style: TextStyle(
                              // fontSize: 75,
                              color: LabColors.defaultCyan,
                              fontFamily: 'Jomhuaria'),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80, // Position at the top
                  left: 0, // Position at the left
                  right: 0, child: displayTextFieldsAndButton(constraints),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget displayTextFieldsAndButton(BoxConstraints constraints) {
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
        FadeInTextField(
          fadeInType: FadeInType.up,
          duration: Duration(milliseconds: 1600),
          controller: password,
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
          prefixIcon: Icon(Icons.password_outlined),
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
        SizedBox(height: 25),
        FadeInUp(
            duration: Duration(milliseconds: 2150),child: GradientButton(onTap: signUp, text: "Sign Up"))
      ],
    );
  }
}
