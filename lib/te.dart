// import 'dart:async';
// import 'package:gymApps/main.dart';
// import 'package:flutter/material.dart';
// import 'package:gymApps/view/signUp.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:gymApps/constant/colours.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:gymApps/widgets/GymAppsStyle.dart';
// import 'package:transparent_image/transparent_image.dart';
//
// import 'package:gymApps/widgets/GymAppsTextField.dart';
//
// class logInPage extends StatefulWidget {
//   const logInPage({super.key});
//
//   @override
//   State<logInPage> createState() => logInPageState();
// }
//
// class logInPageState extends State<logInPage> {
//   late TextEditingController email;
//   late TextEditingController password;
//   late FocusNode emailFocusNode;
//   late FocusNode passwordFocusNode;
//   late GoogleAuthProvider authProvider;
//   late PageController? pageController;
//   late Timer timer;
//
//   int currentPage = 0;
//   bool passwordVisible = false;
//   var imageLists = [
//     "lib/assets/image/banner_slider_0.png",
//     "lib/assets/image/banner_slider_1.png",
//     "lib/assets/image/banner_slider_2.png",
//     "lib/assets/image/banner_slider_3.png"
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     authProvider = GoogleAuthProvider();
//     email = TextEditingController();
//     password = TextEditingController();
//     emailFocusNode = FocusNode();
//     passwordFocusNode = FocusNode();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final orientation = MediaQuery.of(context).orientation;
//       if (orientation == Orientation.landscape) {
//         initializePageController();
//       }
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final orientation = MediaQuery.of(context).orientation;
//       if (orientation == Orientation.landscape) {
//         initializePageController();
//       } else if (orientation == Orientation.portrait) {
//         print('portrait');
//         if (pageController != null) {
//           timer.cancel();
//           pageController?.dispose();
//           pageController = null;
//         }
//       }
//     });
//   }
//
//   void initializePageController() {
//     pageController = PageController(initialPage: currentPage);
//     timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
//       print(currentPage);
//       setState(() {
//         currentPage = ++currentPage % imageLists.length;
//       });
//       if (pageController?.hasClients ?? false) {
//         pageController?.animateToPage(
//           currentPage,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeIn,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     timer.cancel();
//     pageController?.dispose();
//     email.dispose();
//     password.dispose();
//     super.dispose();
//   }
//
//   void googleLogin() async {
//     late UserCredential userCredential;
//     try {
//       if (kIsWeb) {
//         userCredential =
//         await FirebaseAuth.instance.signInWithPopup(authProvider);
//       } else {
//         final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//         final GoogleSignInAuthentication googleAuth =
//         await googleUser!.authentication;
//
//         // Create a GoogleAuthProvider credential
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//
//         // Sign in to Firebase with Google credentials
//         userCredential =
//         await FirebaseAuth.instance.signInWithCredential(credential);
//       }
//
//       if (userCredential.user?.uid != null) {
//         print('Login successfully');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   String validateInput(String email, String password) {
//     if (email.isEmpty) {
//       return 'Please enter your email';
//     } else if (!RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(email)) {
//       return 'Please enter a valid email';
//     } else if (password.isEmpty) {
//       return "Password field is empty";
//     } else {
//       return 'Validated';
//     }
//   }
//
//   void logIn() async {
//     var isValidated = validateInput(email.text, password.text);
//     if (isValidated == 'Validated') {
//       try {
//         final credential = await FirebaseAuth.instance
//             .signInWithEmailAndPassword(
//             email: email.text, password: password.text);
//       } on FirebaseAuthException catch (e) {
//         String errorMessage;
//         if (e.code == 'user-not-found' || e.code == 'invalid-email') {
//           errorMessage = 'No user found for that email.';
//         } else if (e.code == 'wrong-password') {
//           errorMessage = 'Wrong password provided for that user.';
//         } else {
//           errorMessage =
//           'An unexpected error occurred. Please try again later.';
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage)),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         duration: Duration(
//           seconds: 3,
//         ),
//         content: Text(isValidated),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: LayoutBuilder(builder: (context, constraints) {
//           if (constraints.maxWidth > 800) {
//             return buildLogInSectionWithSlider(constraints);
//           } else {
//             return Center(child: buildSimpleLogInSection(constraints));
//           }
//         }),
//       ),
//     );
//   }
//
//   Widget buildLogInSectionWithSlider(BoxConstraints constraints) {
//     MediaQueryData queryData = MediaQuery.of(context);
//     Size deviceSize = queryData.size;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Container(
//           color: Colors.orangeAccent,
//           width: deviceSize.width * 0.7,
//           height: deviceSize.height,
//           child: PageView.builder(
//               controller: pageController,
//               itemCount: imageLists.length,
//               itemBuilder: (context, index) {
//                 return Image.asset(imageLists[index], fit: BoxFit.contain);
//               }),
//         ),
//         buildSimpleLogInSection(constraints)
//       ],
//     );
//   }
//
//   Widget buildSimpleLogInSection(BoxConstraints constraints) {
//
//     return SingleChildScrollView(
//       // child: Container(
//       //   color: Colors.white,
//       //   padding: EdgeInsets.symmetric(horizontal: 20),
//       //   height: constraints.maxHeight,
//       //   width: 450,
//       //   child: Column(
//       //     children: <Widget>[
//       //       FadeInUp(
//       //         duration: Duration(milliseconds: 1000),
//       //         child: Container(
//       //             color: Colors.black,
//       //             width: double.infinity,
//       //             alignment: Alignment.center,
//       //             child: displayRichTitle()),
//       //       ),
//       //       displayTextFieldsAndButton(constraints)
//       //     ],
//       //   ),
//       // ),
//     );
//   }
//
//   Widget displayTextFieldsAndButton(BoxConstraints constraints) {
//     return Column(children: [
//       FadeInTextField(
//         fadeInType: FadeInType.up,
//         duration: Duration(milliseconds: 1200),
//         controller: email,
//         labelText: 'Email',
//         hintText: 'What is your registered email ?',
//         prefixIcon: Icon(Icons.help_outline),
//       ),
//       SizedBox(height: 15),
//       ObscureFadeInTextField(
//         fadeInType: FadeInType.up,
//         duration: Duration(milliseconds: 1600),
//         controller: password,
//         obscureText: passwordVisible,
//         labelText: 'Password',
//         hintText: 'Your password',
//         prefixIcon: Icon(Icons.lock_outline),
//         suffixIcon: IconButton(
//             icon:
//             Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
//             onPressed: () {
//               setState(() {
//                 passwordVisible = !passwordVisible;
//               });
//             }),
//       ),
//       SizedBox(height: 5),
//       FadeInUp(
//           duration: Duration(milliseconds: 1600),
//           child: TextButton(
//               style: ButtonStyle(
//                 overlayColor: WidgetStateProperty.all(Colors.transparent),
//                 // Tắt hiệu ứng hover và click
//                 padding: WidgetStateProperty.all(EdgeInsets.zero),
//                 // Bỏ padding
//                 minimumSize: WidgetStateProperty.all(Size(50, 30)),
//                 // Kích thước tối thiểu
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               ),
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => signUpPage()));
//               },
//               child: Text(
//                 "New To This App ? Let's Sign Up",
//                 style: TextStyle(
//                     color: LabColors.defaultCyan,
//                     fontFamily: 'Jomhuaria',
//                     fontSize: 25),
//               ))),
//       FadeInUp(
//           duration: Duration(milliseconds: 1800),
//           child: TextButton(
//             onPressed: () {
//               // showEmailDialog(context);
//             },
//             style: GymAppsStyle.noneEffectButtonStyle,
//             child: Text(
//               "Forgot Password ?",
//               style: TextStyle(
//                   color: LabColors.defaultCyan,
//                   height: 1,
//                   fontFamily: 'Jomhuaria',
//                   fontSize: 25),
//             ),
//           )),
//       SizedBox(height: 10),
//       FadeInSocialLogInButtons(),
//       //login button
//       SizedBox(height: 20),
//       FadeInUp(
//         duration: Duration(milliseconds: 2200),
//         child: InkWell(
//           onTap: logIn,
//           child: Container(
//             height: 50,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 gradient: LinearGradient(colors: [
//                   LabColors.defaultCyan,
//                   Color.fromRGBO(143, 148, 251, .6),
//                 ])),
//             child: Center(
//               child: Text(
//                 "Login",
//                 style:
//                 TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//       ),
//       SizedBox(height: 35),
//       FadeInImage(
//         placeholder: MemoryImage(kTransparentImage),
//         image: AssetImage('lib/assets/image/swimming.png'),
//         height: constraints.maxHeight * 0.275,
//         fit: BoxFit.cover,
//       )
//     ]);
//   }
//
//   Widget FadeInSocialLogInButtons() {
//     return FadeInUp(
//       duration: Duration(milliseconds: 2000),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//             style: ButtonStyle(
//               elevation: WidgetStateProperty.all(0),
//               overlayColor: WidgetStateProperty.all(Colors.transparent),
//               // Tắt hiệu ứng hover và click
//               padding: WidgetStateProperty.all(EdgeInsets.zero),
//               // Bỏ padding
//               minimumSize: WidgetStateProperty.all(Size(50, 30)),
//               // Kích thước tối thiểu
//               tapTargetSize: MaterialTapTargetSize
//                   .shrinkWrap, // Tắt hiệu ứng ripple mở rộng
//             ),
//             onPressed: googleLogin, // login
//             child: Container(
//               color: Colors.white,
//               width: 50, // Đặt chiều rộng mong muốn
//               height: 50, // Đặt chiều cao mong muốn
//               child: Image.asset(
//                 'lib/assets/icon/google.png',
//                 // Đường dẫn đến hình ảnh của bạn
//                 fit: BoxFit.contain, // Hoặc BoxFit.cover
//               ),
//             ),
//           ),
//           ElevatedButton(
//             style: ButtonStyle(
//               elevation: WidgetStateProperty.all(0),
//               overlayColor: WidgetStateProperty.all(Colors.transparent),
//               // Tắt hiệu ứng hover và click
//               padding: WidgetStateProperty.all(EdgeInsets.zero),
//               // Bỏ padding
//               minimumSize: WidgetStateProperty.all(Size(50, 30)),
//               // Kích thước tối thiểu
//               tapTargetSize: MaterialTapTargetSize
//                   .shrinkWrap, // Tắt hiệu ứng ripple mở rộng
//             ),
//             onPressed: googleLogin, // login
//             child: Container(
//               color: Colors.white,
//               width: 45, // Đặt chiều rộng mong muốn
//               height: 45, // Đặt chiều cao mong muốn
//               child: Image.asset(
//                 'lib/assets/icon/x.png',
//                 // Đường dẫn đến hình ảnh của bạn
//                 fit: BoxFit.contain, // Hoặc BoxFit.cover
//               ),
//             ),
//           ),
//           ElevatedButton(
//             style: ButtonStyle(
//               elevation: WidgetStateProperty.all(0),
//               overlayColor: WidgetStateProperty.all(Colors.transparent),
//               // Tắt hiệu ứng hover và click
//               padding: WidgetStateProperty.all(EdgeInsets.zero),
//               // Bỏ padding
//               minimumSize: WidgetStateProperty.all(Size(50, 30)),
//               // Kích thước tối thiểu
//               tapTargetSize: MaterialTapTargetSize
//                   .shrinkWrap, // Tắt hiệu ứng ripple mở rộng
//             ),
//             onPressed: () {
//               Navigator.pushNamed(context, '/home');
//             }, // login
//             child: Container(
//               color: Colors.white,
//               width: 50, // Đặt chiều rộng mong muốn
//               height: 50, // Đặt chiều cao mong muốn
//               child: Image.asset(
//                 'lib/assets/icon/home.png',
//                 // Đường dẫn đến hình ảnh của bạn
//                 fit: BoxFit.contain, // Hoặc BoxFit.cover
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget displayRichTitle() {
//     return RichText(
//         text: TextSpan(children: [
//           TextSpan(
//               text: "Crossfit ",
//               style: TextStyle(
//                   color: LabColors.gradientStart,
//                   fontFamily: 'Oswald',
//                   fontWeight: FontWeight.w400
//               )),
//           TextSpan(
//             text: "|",
//             style: TextStyle(
//                 color: LabColors.gradientMid,
//                 fontFamily: 'Oswald',
//                 fontWeight: FontWeight.w400),
//           ),
//           TextSpan(
//               text: " Log In",
//               style: TextStyle(
//                   color: LabColors.gradientEnd,
//                   fontFamily: 'Oswald',
//                   fontWeight: FontWeight.w400))
//         ]));
//   }
// }
