import 'package:firbasecrud/firebasecrud/pages/add_student_page.dart';
import 'package:firbasecrud/firebasecrud/pages/student_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    TextStyle titles = const TextStyle(
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter Firebase Crud",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) =>const AddStudentPage(),
                      )
                    );
                },
                child: const Text("Add")),
          ),
        ],
      ),
      // body: StudentListPage(),
    );
  }
}
