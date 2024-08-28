
import 'package:check/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'display_users.dart';
import 'login.dart';




CollectionReference users = FirebaseFirestore.instance.collection('user_master');

Future<List<Map<String, dynamic>>> getUserData() async {
  print("Inside get user fn...");
  QuerySnapshot snapshot = await users.get();
  return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAWkTfiO5ee9M7DSEMy7hZlRea01eM1jrE",
        appId: "1:567902013970:android:a6e83d21bbc8a6b45126cb",
        messagingSenderId: "567902013970",
        projectId: "check-82263",
      ),
    );
    runApp(MaterialApp(
      title: 'Flutter Firebase',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyApp(),
    ));
  } catch (error) {
    print("Error initializing Firebase: $error");
  }
}
// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 150.0,
            ),
            ElevatedButton(
                style: ButtonStyle(


                  backgroundColor: WidgetStateProperty.all(Colors.blueAccent)
                ),
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>LoginPage())
                  );
                },
                child: Text("Sign In",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white
                  ),
                )
            ),
            SizedBox(
              height: 80.0,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.greenAccent)
                ),
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>RegisterPage())
                  );
                },
                child: Text("Sign Up",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white
                  ),


                )
            ),
            SizedBox(
              height: 80.0,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.pinkAccent),
              ),
              onPressed: () async {
                List<Map<String, dynamic>> userData = await getUserData();
                print(userData);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayUsers(userData: userData),
                  ),
                );
              },
              child: Text(
                "Display Users",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            )

          ],
        ),
      ),
    );

  }
}

