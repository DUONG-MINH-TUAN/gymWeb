import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
class loginPage extends StatefulWidget {
  const loginPage({super.key, required this.title});
  final String title;
  @override
  State<loginPage> createState() => _loginState();
}

class _loginState extends State<loginPage> {
  late TextEditingController email;
  late TextEditingController password;
  late GoogleAuthProvider authProvider;



  void Googlelogin() async {
    late UserCredential credential;
    try {
      if (kIsWeb) {
        credential = await FirebaseAuth.instance.signInWithPopup(authProvider);
      } else {}

      if (credential.user?.uid != null) {
        print('login successfully');
      }
    } catch (e) {
      print(e);
    }
  }

  String validateInput(String email, String password) {
    if (email.isEmpty) { //
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

  void logIn() async {
    var isValidated = validateInput(email.text, password.text);
    if (isValidated == 'Validated') {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email.text, password: password.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'invalid-email') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else {
          print(e);
        }
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
  void initState() {
    super.initState();
    authProvider = GoogleAuthProvider();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Login Page'),
        actions: [
          //login button
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.home))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '--Login--',
              style: TextStyle(
                fontSize: 32,
                color: Colors.cyan[400],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(), // Circular shape
                elevation: 0, // No shadow, // Padding can be adjusted
              ),
              onPressed: Googlelogin, // login
              child: Image.asset(
                'lib/icon/Google.png',
                width: 40,
                height: 40,
              ),
            ),
            //login button
            SizedBox(height: 10),
            Container(
              width: 120,
              height: 120,
              child: ElevatedButton(
                onPressed: logIn, // login
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
