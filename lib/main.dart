import 'package:firbasecrud/firebasecrud/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebasecrud/pages/student_list_page.dart';


 

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDZxnU_pViSdJD6JeFQyTjhoTqHTabLEJw",
      appId: "1:831989861571:web:d177e0d9620659acb72676",
      messagingSenderId: "831989861571",
      projectId: "crud-a4089",
      )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  MyApp({super.key});

  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        //check for Errors
        if(snapshot.hasError){
          print("Something went wrong");
        }
        //once completed, show your application
        if(snapshot.connectionState == ConnectionState.done){
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
            home:  HomePage(),
          );
        }
        return const CircularProgressIndicator();
      },
      );
    
  }
}


