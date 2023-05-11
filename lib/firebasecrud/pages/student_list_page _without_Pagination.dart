import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbasecrud/firebasecrud/pages/update_student_page.dart';
import 'package:flutter/material.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final Stream<QuerySnapshot> studentsStream = FirebaseFirestore.instance.collection('students')
  .orderBy('created_at', descending: true)
  // .orderBy('created_at')
  .snapshots();
  

  CollectionReference students = FirebaseFirestore.instance.collection('students'); 

  Future<void> deleteUser(id) {
    // print("User Deleted $id");
    return students.doc(id).delete().then((value) => print('User Deleted $id'))
    .catchError((error)=>print('Failed to delete user: $error'));
  }
  @override
  Widget build(BuildContext context) {
       
    TextStyle titles = const TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

     TextStyle titlesRow = const TextStyle(
      fontStyle: FontStyle.normal,
      fontSize: 18,
    );
    return StreamBuilder<QuerySnapshot>(stream: studentsStream ,builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
      if(snapshot.hasError){
        print("something went wrong");
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Center(
         child: CircularProgressIndicator(),
        );
      }
      
      final List storedocs = [];

      snapshot.data!.docs.map((DocumentSnapshot document){
       Map a=  document.data() as Map<String, dynamic> ;
       storedocs.add(a);
       a['id'] = document.id;
      }).toList();

      return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(100),
          },   
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text("Sl No", style: titles,),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text("Name", style: titles,),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text("Email", style: titles,),
                    ),
                  ),
                ),
                 TableCell(
                  child: Container(
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text("Date of birth", style: titles,),
                    ),
                  ),
                ),
                 TableCell(
                  child: Container(
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text("Created At", style: titles,),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text("Updated At", style: titles,),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text("Action", style: titles,),
                    ),
                  ),
                ),
              ]
            ),
            for(var i = 0; i <storedocs.length; i++)...[
            TableRow(
              children: [
                TableCell(
                  child: Center(
                    child: Text((i+1).toString(), style: titlesRow,),
                  )
                  ),

                   TableCell(
                  child: Center(
                    child: Text(storedocs[i]['name'], style: titlesRow,),
                  )
                  ),

                  TableCell(
                  child: Center(
                    child: Text(storedocs[i]['email'], style: titlesRow,),
                  ),
                  ),
                  TableCell(
                  child: Center(
                    child: Text(storedocs[i]['date_of_birth'] ?? '', style: titlesRow,),
                  ),
                  ),
                  TableCell(
                  child: Center(
                    child: Text(storedocs[i]['created_at'].toDate().toString(), style: titlesRow,),
                  ),
                  ),
                  TableCell(
                  child: Center(
                    child: Text(storedocs[i]['updated_at'].toDate().toString(), style: titlesRow,),
                  ),
                  ),
                TableCell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context)=> UpdateStudentPage(
                                id: storedocs[i]['id'],
                                dob: storedocs[i]['date_of_birth']
                                ),
                              )
                            );
                        }, 
                        icon: const Icon(Icons.edit, color: Colors.orange,)),

                        IconButton(
                        onPressed: (){
                        deleteUser(storedocs[i]['id']);
                        // print(storedocs[i]['id']);
                        
                        }, 
                        icon: const Icon(Icons.delete, color: Colors.orange,))
                    ],
                  )
                  )  
              ]
            ),
            ],
          ],
        ),
      ),
    );

    });

    
   
  }
}