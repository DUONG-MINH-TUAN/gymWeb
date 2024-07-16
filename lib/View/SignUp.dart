import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key, required this.title});

  final String title;

  @override
  State<signUpPage> createState() => _signUpState();
}

class _signUpState extends State<signUpPage> {
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController password;

  // late GoogleAuthProvider authProvider;

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

  // void Googlelogin() async {
  //   late UserCredential credential;
  //   try {
  //     if (kIsWeb) {
  //       credential = await FirebaseAuth.instance.signInWithPopup(authProvider);
  //     } else {}
  //
  //     if (credential.user?.uid != null) {
  //       print('login successfully');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // tự động chạy khi tạo page này
  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    // authProvider = GoogleAuthProvider();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up Page'),
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
              '--Sign up--',
              style: TextStyle(
                fontSize: 32,
                color: Colors.cyan[400],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: TextFormField(
                controller: username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
            ),
            SizedBox(height: 10),
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
            //login button
            Container(
              width: 120,
              height: 120,
              child: ElevatedButton(
                onPressed: signUp, // login
                child: const Text('Sign up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
