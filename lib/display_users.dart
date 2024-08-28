import 'package:check/update_users.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayUsers extends StatefulWidget {
  const DisplayUsers({Key? key, required this.userData}) : super(key: key);

  final List<Map<String, dynamic>> userData;

  @override
  State<DisplayUsers> createState() => _DisplayUsersState();
}

class _DisplayUsersState extends State<DisplayUsers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(child: Text("Users List")),
        ),
        body: ListView.builder(
          itemCount: widget.userData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Card(
                child: ListTile(
                  title: Text(widget.userData[index]['name']),
                  subtitle: Text(widget.userData[index]['email_id']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to UpdateUsers page when edit button is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateUsers(userData: widget.userData[index]),
                            ),
                          );

                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Call function to delete user when delete button is tapped
                          _deleteUser(widget.userData[index]['email_id']);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('user_master');
      QuerySnapshot snapshot = await users.get();
      setState(() {
        widget.userData.clear();
        widget.userData.addAll(snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
      });
    } catch (e) {
      if (_scaffoldKey.currentState != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Your message here'),
        ));

      }
    }
  }

  // Function to delete user from Firestore
  void _deleteUser(String email) async {
    try {
      // Query Firestore for the document with the provided email ID
      final querySnapshot = await _firestore.collection('user_master').where('email_id', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delete the first document found with the provided email ID
        final docId = querySnapshot.docs.first.id;
        await _firestore.collection('user_master').doc(docId).delete();

        // Show a snackbar to indicate success
        if (_scaffoldKey.currentState != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('User Deleted'),
          ));
        }

        // Refresh the page
        _refreshData();

      } else {
        // Show a snackbar to indicate that the user was not found
        if (_scaffoldKey.currentState != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Your message here'),
          ));
        }
      }
    } catch (e) {
      // Show a snackbar to indicate error
      if (_scaffoldKey.currentState != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${e}'),
        ));
      }
    }
  }
}

