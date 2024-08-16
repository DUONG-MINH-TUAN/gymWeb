import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gymApps/View/resetPassword.dart';

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
  late TextEditingController forgotPassword;
  late UserCredential credential1;
  String _selectedLanguage = 'English';
  late String userEmail;
  final List<String> _languages = [
    'English',
    'Vietnamese',
    'Francais',
    'Deutsch',
  ];


  void signUp() async {
    var isValidated = validateInput(username.text, email.text, password.text);
    // thiếu phần username
    bool isError = false;
    if (isValidated == 'Validated') {

      try {
         credential1 = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
         credential1.user?.sendEmailVerification();
         userEmail = credential1.user?.email ?? "";
        print("Successful login");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }

  }
    else print(isValidated);
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
        title: Row(
          children: [
            Image.asset('lib/assets/icon/barbell.png',
              height: 40,
              width: 40,
            ),
            SizedBox(width: 10,),
            Text('Sign up page')
            ,
            Spacer(),
            Container(
              width: 95,
              height:20,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedLanguage,
                  icon: Icon(Icons.language),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                  items: _languages.map<DropdownMenuItem<String>>((
                      String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return _languages.map<Widget>((String value) {
                      return
                        Text(
                          _selectedLanguage,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        );
                    }).toList();
                  },
                ),
              ),
            ),
          ],
        ),
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
              'Sign up your fitness account',
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
              height: 30,
              child: ElevatedButton(
                onPressed: signUp, // login
                child: const Text('Sign up'),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 120,
              height: 40,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => resetPage()),
                  );
                }, // reset password
                child: const Text('Forgot password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
