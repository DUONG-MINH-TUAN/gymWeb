import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymApps/View/signUp.dart';
import 'package:gymApps/View/logIn.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // runApp(MyEnglishLearningApp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomePage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.white,
        actions: [
          //login button
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => logInPage()),
                );
              },
              icon: Icon(Icons.login)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => signUpPage(title: '',)),
                );
              },
              icon: Icon(Icons.person_add))
        ],
      ),
    );
  }
}
//
// class SignUpPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign Up Page')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context); // Quay lại trang LoginPage
//           },
//           child: Text('Back to Login'),
//         ),
//       ),
//     );
//   }
// }
//
// class loginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login Page'),
//         backgroundColor: Colors.white,
//         actions: [
//           //login button
//           IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(Icons.home))
//         ],
//       ),
//     );
//   }
// }
