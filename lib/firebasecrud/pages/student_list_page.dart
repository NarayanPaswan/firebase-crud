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
  
  /*
  @override
  void initState() {
    super.initState();
    
    studentsStream.listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print(doc.data());
      });
    });
  }
  */
  CollectionReference students = FirebaseFirestore.instance.collection('students'); 

  Future<void> deleteUser(id) {
    // print("User Deleted $id");
    return students.doc(id).delete().then((value) => print('User Deleted $id'))
    .catchError((error)=>print('Failed to delete user: $error'));
  }

int _rowPerPage =  PaginatedDataTable.defaultRowsPerPage;
  @override
  Widget build(BuildContext context) {
   
    return StreamBuilder<QuerySnapshot>(
      stream: studentsStream ,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
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

      return SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                 
                child: PaginatedDataTable(
                  header: const Text("Student's data", style: TextStyle(color: Colors.red),),
                  columns:   [
                      DataColumn(label: Text("Sl No",),
                       tooltip: 'Sl No',
                       onSort: (columnIndex, ascending) {
                        setState(() {
                          if (ascending) {
                            storedocs.sort((a, b) => a['id'].compareTo(b['id']));
                          } else {
                            storedocs.sort((a, b) => b['id'].compareTo(a['id']));
                          }
                        });
                      },


                      ),
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Email"),),
                      DataColumn(label: Text("Date of birth")),
                      DataColumn(label: Text("Created At")),
                      DataColumn(label: Text("Updated At")),
                      DataColumn(label: Text("Action")),
                    ], 
                   
                   source: StudentDataSource(context, storedocs, deleteUser),
                   
                   onRowsPerPageChanged: (value) {
                     setState(() {
                       _rowPerPage = value!;
                     });
                   },
                  //  rowsPerPage: 5,
                  rowsPerPage: _rowPerPage,
                 
                  
                  ),
              ),
            ),
          ],
        ),
      );
    },
    );
    
  }
  
}

class StudentDataSource extends DataTableSource {
  StudentDataSource(this.context, this.storedocs, this.deleteUser);

  final BuildContext context;
  final List storedocs;
  final Function(String) deleteUser;

  @override
  DataRow getRow(int index) {
    final doc = storedocs[index];
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(doc['name'])),
        DataCell(Text(doc['email'])),
        DataCell(Text(doc['date_of_birth'] ?? '')),
        DataCell(Text(doc['created_at'].toDate().toString())),
        DataCell(Text(doc['updated_at'].toDate().toString())),
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateStudentPage(
                      id: doc['id'],
                      dob: doc['date_of_birth'],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.orange),
            ),
            IconButton(
              onPressed: () {
                deleteUser(doc['id']);
              },
              icon: const Icon(Icons.delete, color: Colors.orange),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => storedocs.length;

  @override
  int get selectedRowCount => 0;
}
