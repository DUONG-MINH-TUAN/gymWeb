import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:flutter/foundation.dart' show kIsWeb;

class resetPage extends StatefulWidget {
  // final UserCredential credential;
   const resetPage({super.key});

  @override
  State<resetPage> createState() => _resetState();
}

class _resetState extends State<resetPage> {
  late TextEditingController email;
  late String userEmail;



  void authenticateEmail() async {
    var isValidated = validateEmail(email.text);
    print(isValidated);
    print(email.text);
    if (isValidated =='Validated'){
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

      } on FirebaseAuthException catch(e){

        print(e.code);
      }
      }
  }


  String validateEmail(String email) {

    if (email.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return 'Validated';
  }
  void initState() {
    super.initState();

    // authProvider = GoogleAuthProvider();
    email = TextEditingController();

  }

  @override
  void dispose() {

    email.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'AUTHENTICATE YOUR EMAIL',
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
            //login button
            Container(
              width: 120,
              height: 40,
              child: ElevatedButton(
                onPressed: authenticateEmail, // login
                child: Text('Authenticate your email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
