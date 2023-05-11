import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/mock/static_json.dart';

class UpdateStudentPage extends StatefulWidget {
  final String id;
  final String? dob;

  const UpdateStudentPage({super.key, required this.id, this.dob});

  @override
  State<UpdateStudentPage> createState() => _UpdateStudentPageState();
}
  List<String> gender = ['Male','Female'];
class _UpdateStudentPageState extends State<UpdateStudentPage> {
  
  final _formKey = GlobalKey<FormState>();
  var name = '';
  var email = '';
  var password = '';
  var date_of_birth_new ='';
  String? chooseYesNo;
  String? selectedCompany;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  bool? isMarriedChecked = false;
  bool? isUnMarriedChecked = false;
  String? maritalStatus;
  String? currentGender;
  

  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateOfBirthController.text = widget.dob.toString();
    FirebaseFirestore.instance
    .collection('students')
    .doc(widget.id)
    .get()
    .then((snapshot) {
      setState(() {
        chooseYesNo = snapshot.data()!['yesno'];
        selectedCompany = snapshot.data()!['company'];
        selectedCountry = snapshot.data()!['country_id'];
        selectedState = snapshot.data()!['state_id'];
        selectedCity = snapshot.data()!['city_id'];
         String maritalStatus = snapshot.data()!['marital_status'];
        if (maritalStatus == 'Married') {
          isMarriedChecked = true;
          isUnMarriedChecked = false;
        } else if (maritalStatus == 'Unmarried') {
          isMarriedChecked = false;
          isUnMarriedChecked = true;
        }
        currentGender = snapshot.data()!['gender'];
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateOfBirthController.dispose();
    super.dispose();
  }


  //update student
   CollectionReference students = FirebaseFirestore.instance.collection('students');
   
   Future<void> updateUser(id, name, email, password, date_of_birth, chooseYesNo, 
    selectedCompany, selectedCountry, selectedState, selectedCity, isMarriedChecked, 
    isUnMarriedChecked, currentGender) async {
  try {
    // set maritalStatus variable based on the checkbox value
    if (isMarriedChecked == true) {
      maritalStatus = "Married";
    } else if (isUnMarriedChecked == true) {
      maritalStatus = "Unmarried";
    }
    await students.doc(id).update({
      'name': name,
      'email': email,
      'password': password,
      'date_of_birth': date_of_birth,
      'yesno': chooseYesNo,
      'company': selectedCompany,
      'country_id': selectedCountry,
      'state_id': selectedState,
      'city_id': selectedCity,
      'marital_status': maritalStatus, 
      'gender': currentGender, 
      'updated_at': Timestamp.now(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User updated'),
      ));
    }
  } catch (error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update user'),
      ));
    }
    throw error;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Student"),
      ),
      body: Form(
        key: _formKey,
        //geting specific data by id
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
          .collection('students')
          .doc(widget.id)
          .get(),
          
          builder: (_, snapshot){
            if(snapshot.hasError){
              print("something went wrong");
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.data();
            var name = data!['name'];
            var email = data['email'];
            var password = data['password'];
            var date_of_birth = data['date_of_birth'];
            
            return Padding(
          padding: const EdgeInsets.symmetric(horizontal:30.0, vertical: 30.0),
          child: ListView(
            children: [
              Row(
                children: [

                  Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    initialValue: name,
                    autofocus: false,
                    onChanged: (value)=> name = value,
                    decoration: const InputDecoration(
                      labelText: 'Name: ',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                      errorStyle: 
                      TextStyle(
                        color: Colors.redAccent, fontSize: 15,
                      ),
                    ),
                    
                    validator: (value){
                      if(value == null  || value.isEmpty){
                        return "Please enter text";
                      }
                      return null;
                    },
              
                  ),
                ),
              ),

              const SizedBox(width: 10,),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    initialValue: email,
                    autofocus: false,
                    onChanged: (value)=> email = value,
                    decoration: const InputDecoration(
                      labelText: 'Email: ',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                      errorStyle: 
                      TextStyle(
                        color: Colors.redAccent, fontSize: 15,
                      ),
                    ),
                    
                    validator: (value){
                      if(value == null  || value.isEmpty){
                        return "Please enter email";
                      }else if(!value.contains('@')){
                        return "Please enter valid email";
                      }
                      return null;
                    },
              
                  ),
                ),
              ),
                ],
              ),

              Row(
                children: [

                  Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    initialValue: password,
                    autofocus: false,
                    onChanged: (value)=> password = value,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password: ',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                      errorStyle: 
                      TextStyle(
                        color: Colors.redAccent, fontSize: 15,
                      ),
                    ),
                    
                    validator: (value){
                      if(value == null  || value.isEmpty){
                        return "Please enter password";
                      }
                      return null;
                    },
              
                  ),
                ),
              ),

              const SizedBox(width: 10,),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _dateOfBirthController,
                    // initialValue: date_of_birth,
                    readOnly : true,
                    autofocus: false,
                    onChanged: (value) => date_of_birth = value,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today_rounded),
                      labelText: 'Select date of birth: ',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                      errorStyle: 
                      TextStyle(
                        color: Colors.redAccent, fontSize: 15,
                      ),
                    ),
                    
                    onTap: ()async{
                      DateTime? pickDate = await showDatePicker(
                        context: context, 
                        initialDate: DateTime.now(), 
                        firstDate: DateTime(1950), 
                        lastDate: DateTime.now()
                        );
                        if (pickDate != null){
                        setState(() {
                           _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(pickDate);
                         
                        });
                      
                        } 
                    },
              
                  ),
                ),
              ),


                ],
              ),

              Row(
                children: [
                  Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          height: 40,
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton(
                            hint: const Text("Please select"),
                            isExpanded: true,
                            underline: const SizedBox(),
                            value: chooseYesNo ?? data['yesno'],
                            onChanged: (newYesNo) {
                              setState(() {
                                chooseYesNo = newYesNo.toString();
                              });
                            },
                            items: yes_no.map((valueYesNo) {
                              return DropdownMenuItem<String>(
                                value: valueYesNo,
                                child: Text(valueYesNo),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          height: 40,
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('company')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print("something went wrong");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Only show the progress bar if selectedCompany is null
                                if (selectedCompany == null) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  // If selectedCompany is not null, show an empty container instead
                                  return const SizedBox();
                                }
                              } else {
                                List<DropdownMenuItem> companyList = [];
                                for (int i = 0;
                                    i < snapshot.data!.docs.length;
                                    i++) {
                                  DocumentSnapshot snap =
                                      snapshot.data!.docs[i];
                                  companyList.add(
                                    DropdownMenuItem(
                                      // value: "${snap.id}",
                                      value: "${snap.get("name")}",
                                      child: Text(
                                        snap.get("name"),
                                      ),
                                    ),
                                  );
                                }

                                return DropdownButton(
                                  hint: const Text("Select Company"),
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  value: selectedCompany ?? data['company'],
                                  items: companyList,
                                  onChanged: (newCompany) {
                                    setState(() {
                                      selectedCompany = newCompany;
                                      
                                      print(selectedCompany);
                                    });
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      )

                ],
              ),

              Row(
                children: [
                  Expanded(
                        child: Container(
                           margin: const EdgeInsets.symmetric(vertical: 10.0),
                            height: 40,
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('countries')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                        
                              final countriesList = snapshot.data!.docs
                                  .map((doc) => DropdownMenuItem(
                                        value: doc.id,
                                        child: Text(doc.get('country_name')),
                                      ))
                                  .toList();
                        
                              return DropdownButton(
                                value: selectedCountry ?? data['country_id'],
                                hint: const Text('Select a country'),
                                isExpanded: true,
                                underline: const SizedBox(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCountry = value as String;
                                    print(selectedCountry);
                                    selectedState =null; // Clear the selected state when a new country is selected
                                  });
                                },
                                items: countriesList,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                              height: 40,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('states')
                                  .where('country_id', isEqualTo: selectedCountry)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                          
                                final statesList = snapshot.data!.docs
                                    .map((doc) => DropdownMenuItem(
                                          value: doc.id,
                                          child: Text(doc.get('state_name')),
                                        ))
                                    .toList();
                          
                                return DropdownButton(
                                  value: selectedState ?? data['state_id'],
                                  hint: const Text('Select a state'),
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedState = value as String?;
                                      selectedCity =null;
                                    });
                                  },
                                  items: statesList,
                                );
                              },
                            ),
                          ),
                        ),   
                ],
              ),

              Row(
                    children: [
                      if (selectedState != null)
                      Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                              height: 40,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('cities')
                                  .where('state_id', isEqualTo: selectedState)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                          
                                final citiesList = snapshot.data!.docs
                                    .map((doc) => DropdownMenuItem(
                                          value: doc.id,
                                          child: Text(doc.get('city_name')),
                                        ))
                                    .toList();
                          
                                return DropdownButton(
                                  value: selectedCity ?? data['city_id'],
                                  hint: const Text('Select a City'),
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCity = value as String?;
                                    });
                                  },
                                  items: citiesList,
                                );
                              },
                            ),
                          ),
                        ),   
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text("Married"),
                          value: isMarriedChecked, 
                          onChanged: (bool? newMarriedValue){
                            setState(() {
                              isMarriedChecked = newMarriedValue ?? false;
                              if(isMarriedChecked = true){
                                isUnMarriedChecked = false;
                              }
                              print(isMarriedChecked);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          
                          ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text("Unmarried"),
                          value: isUnMarriedChecked, 
                          onChanged: (bool? newUnMarriedValue){
                            setState(() {
                              isUnMarriedChecked = newUnMarriedValue ?? false;
                              if(isUnMarriedChecked = true){
                                isMarriedChecked = false;
                              }
                              print(isUnMarriedChecked);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          
                          ),
                      ),
                    ],
                  ),

                Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Radio(
                              value: gender[0], 
                              groupValue: currentGender, 
                              onChanged: (maleValue){
                                setState(() {
                                  currentGender = maleValue as String;
                                });
                              }
                              ),
                               const SizedBox(width: 20.0,),
                               const Text("Male"),
                            ],
                          ),
                      
                        ),
                      ),
                      const SizedBox(width: 10,),

                      Expanded(
                        child: Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Radio(
                              value: gender[1], 
                              groupValue: currentGender, 
                              onChanged: (femaleValue){
                                  setState(() {
                                    currentGender = femaleValue as String;
                                  });
                                }
                            
                              ),
                               const SizedBox(width: 20.0,),
                               const Text("Female"),
                            ],
                          ),
                      
                        ),
                      ),

                    ],
                  ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      //validate return true if the form is valid, other wise false.
                      if(_formKey.currentState!.validate()){
                        updateUser(widget.id, name, email, password, 
                        date_of_birth = _dateOfBirthController.text,
                        chooseYesNo, selectedCompany, selectedCountry, selectedState,
                        selectedCity, isMarriedChecked, isUnMarriedChecked, currentGender
                        );
                        Navigator.pop(context);
                      }
                    }, 
                    child: const Text("Update"),
                  ),
                 const SizedBox(width: 30,),
                  ElevatedButton(
                    onPressed: (){
                       Navigator.pop(context);
                    }, 
                   
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                     child: const Text("Back"),
                    )
                ],
              )


              
            ],
          ),
        );
          }
          )
      
      )
    );
  }
}