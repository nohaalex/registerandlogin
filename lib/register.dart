import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';


late String name;
late String password;
late String emailid;
late String mobileNo;
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Screen"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  onChanged: (i){
                    name = i;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter Your Name'
                  ),
                ),

              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  onChanged: (i){
                    emailid = i;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter Your Email'
                  ),
                ),

              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  onChanged: (i){
                    mobileNo = i;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mobile No',
                      hintText: 'Enter Your Mobile No'
                  ),
                ),

              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  onChanged: (i){
                    password = i;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter Your Password'
                  ),
                ),

              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Create a new user in Firebase Authentication
                    final newUser = await _auth.createUserWithEmailAndPassword(email: emailid, password: password);

                    // Check if user creation is successful
                    if (newUser != null) {
                      print("User created successfully: $newUser");

                      // Add user information to Firestore
                      await _firestore.collection('user_master').add({
                        'email_id': emailid,
                        'name': name,
                        'mobileNo': mobileNo,
                      });

                      print("User data added to Firestore successfully");

                      // Navigate to the login page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                  } catch (e) {
                    // Handle any errors that occur during user creation or Firestore update
                    print("Error: $e");
                  }
                },
                child: Text("Register"),
              )

            ],
          ),
        ),
      ),
    );
  }
}
