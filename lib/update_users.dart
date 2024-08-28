import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'display_users.dart';

CollectionReference users = FirebaseFirestore.instance.collection('user_master');

Future<List<Map<String, dynamic>>> getUserData() async {
  print("Inside get user fn...");
  QuerySnapshot snapshot = await users.get();
  return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}


class UpdateUsers extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UpdateUsers({Key? key, required this.userData}) : super(key: key);

  @override
  _UpdateUsersState createState() => _UpdateUsersState();
}

class _UpdateUsersState extends State<UpdateUsers> {

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileNoController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['name']);
    emailController = TextEditingController(text: widget.userData['email_id']);
    mobileNoController = TextEditingController(text: widget.userData['mobileNo']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update User"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name"),
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Enter Name"),
            ),
            SizedBox(height: 20),
            Text("Email"),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: "Enter Email"),
            ),
            SizedBox(height: 20),
            Text("Mobile No"),
            TextField(
              controller: mobileNoController,
              decoration: InputDecoration(hintText: "Enter Mobile No"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update the user data in Firebase Firestore
                _updateUserData();
              },
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserData() async {
    try {
      // Query Firestore for the document with the provided email ID
      final querySnapshot = await _firestore.collection('user_master').where('email_id', isEqualTo: widget.userData['email_id']).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the first document found with the provided email ID
        final docId = querySnapshot.docs.first.id;
        await _firestore.collection('user_master').doc(docId).update({
          'name': nameController.text,
          'email_id': emailController.text,
          'mobileNo': mobileNoController.text,
        });

        // Show a snackbar to indicate success
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User data updated successfully'),
          backgroundColor: Colors.green,

        ));
        List<Map<String, dynamic>> userData = await getUserData();
        Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayUsers(userData: userData)));
      } else {
        // Show a snackbar to indicate that the user was not found
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User not found'),
        ));
      }
    } catch (e) {
      // Show a snackbar to indicate error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating user data: $e'),
      ));
    }
  }
}
