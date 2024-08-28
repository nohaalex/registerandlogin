import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String email = "";
  String password = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                onChanged: (input) {
                  setState(() {
                    email = input;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                  hintText: "Enter your email",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                onChanged: (input) {
                  setState(() {
                    password = input;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  hintText: "Enter your password",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // If login is successful, you can navigate to the next screen or perform other actions.
                  print("Login successful: ${userCredential.user?.email}");



                } catch (e) {
                  print("Login failed: $e");
                }
              },
              child: Text("Sign In"),
            )
          ],
        ),
      ),
    );
  }
}
