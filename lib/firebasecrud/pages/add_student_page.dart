import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/mock/static_json.dart';
import 'package:flutter/services.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}
List<String> gender = ['Male','Female'];
class _AddStudentPageState extends State<AddStudentPage> {
  
  String currentGender = '';

  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('students').snapshots();
 bool _value = false;
  final _formKey = GlobalKey<FormState>();
  var name = '';
  var email = '';
  var password = '';
  var date_of_birth = '';
  String? chooseYesNo;
  String? selectedCompany;
  String? selectedBankAccountExist;
  bool isBankAccountEnabled = false;

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  bool? isMarriedChecked = false;
  bool? isUnMarriedChecked = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final bankAccountNoController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    dateOfBirthController.dispose();
    bankAccountNoController.dispose();

    super.dispose();
  }

  //adding student data
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  Future<void> addUser() async{
    final CollectionReference countries = FirebaseFirestore.instance.collection('countries');
  String countryName = '';
  final countryDoc = await countries.doc(selectedCountry).get();
  if (countryDoc.exists) {
    final countryData = countryDoc.data() as Map<String, dynamic>;
    countryName = countryData['country_name'] ?? '';
  }
  // await countries.doc(selectedCountry).get().then((doc) {
  //   countryName = doc.get('country_name');
  // });
    // print("add user");
    return students.add({
      'name': name,
      'email': email,
      'password': password,
      'date_of_birth': date_of_birth,
      'yesno': chooseYesNo,
      'company': selectedCompany,
      'country_id': selectedCountry,
      'country_name': countryName,
      'state_id': selectedState,
      'city_id': selectedCity,
      // 'marital_status': isMarriedChecked! ? 'Married' : 'Unmarried',
      'marital_status': isMarriedChecked! ? 'Married' : isUnMarriedChecked! ? 'Unmarried' : '',
      'gender': currentGender,
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    }).then((value) {
      setState(() {
        chooseYesNo = null; // Clear selected yes no
        selectedCompany = null;
        selectedCountry = null;
        selectedState = null;
        selectedCity =  null;
        isMarriedChecked = false; 
        isUnMarriedChecked = false;
        currentGender ='';
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User Added'),
      ));
    }).catchError((error) => print('Failed to add user: $error'));
  }

  clearText() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    dateOfBirthController.clear();
    bankAccountNoController.clear();
        
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add New Student"),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: ListView(
                children: [
                   Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 0.01, color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            autofocus: false,
                            decoration: const InputDecoration(
                              labelText: 'Name: ',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(),
                              errorStyle: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15,
                              ),
                            ),
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter text";
                              }
                              return null;
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
                          child: TextFormField(
                            autofocus: false,
                            decoration: const InputDecoration(
                              labelText: 'Email: ',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(),
                              errorStyle: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15,
                              ),
                            ),
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter email";
                              } else if (!value.contains('@')) {
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
                            autofocus: false,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password: ',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(),
                              errorStyle: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15,
                              ),
                            ),
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter password";
                              }
                              return null;
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
                          child: TextFormField(
                            readOnly: true,
                            autofocus: false,
                            decoration: const InputDecoration(
                              // icon: Icon(Icons.calendar_today_rounded),
                              suffixIcon: Icon(Icons.calendar_today_rounded),
                              labelText: 'Select date of birth: ',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(),
                              errorStyle: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15,
                              ),
                            ),
                            controller: dateOfBirthController,
                            onTap: () async {
                              DateTime? pickDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now());
                              if (pickDate != null) {
                                setState(() {
                                  dateOfBirthController.text =
                                      DateFormat('yyyy-MM-dd').format(pickDate);
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
                            value: chooseYesNo,
                            onChanged: (newYesNo) {
                              setState(() {
                                chooseYesNo = newYesNo;
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
                                  value: selectedCompany,
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
                                .collection('bank_account_exist')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print("something went wrong");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                if (selectedBankAccountExist == null) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              } else {
                                List<DropdownMenuItem> bankAccountExistList =
                                    [];
                                for (int i = 0;
                                    i < snapshot.data!.docs.length;
                                    i++) {
                                  DocumentSnapshot snap =
                                      snapshot.data!.docs[i];
                                  bankAccountExistList.add(
                                    DropdownMenuItem(
                                      // value: "${snap.id}",
                                      value: "${snap.get("exist")}",
                                      child: Text(
                                        snap.get("exist"),
                                      ),
                                    ),
                                  );
                                }

                                return DropdownButton(
                                  hint: const Text("Please select"),
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  value: selectedBankAccountExist,
                                  items: bankAccountExistList,
                                  onChanged: (newBankAccountExist) {
                                    setState(() {
                                      selectedBankAccountExist =
                                          newBankAccountExist;
                                      isBankAccountEnabled =
                                          selectedBankAccountExist == 'Yes';
                                      print(selectedBankAccountExist);
                                    });
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 40.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 0.01, color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          
                          child: AbsorbPointer(
                            absorbing: !isBankAccountEnabled,
                            child: Opacity(
                              opacity: isBankAccountEnabled ? 1.0 : 0.5,
                              child: TextFormField(
                                autofocus: false,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  labelText: 'Bank account no: ',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(),
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 15,
                                  ),
                                ),
                                controller: bankAccountNoController,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // allow only digits
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter bank account no.";
                                  } else if (value.length != 10) {
                                    return "Please enter a 10 digit no";
                                  } else if (!RegExp(r'^[0-9]+$')
                                      .hasMatch(value)) {
                                    return "Please enter valid number";
                                  }
                                  return null;
                                },
                              ),
                            ),
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
                                value: selectedCountry,
                                hint: const Text('Select a country'),
                                isExpanded: true,
                                underline: const SizedBox(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCountry = value as String?;
                                    selectedState =
                                        null; // Clear the selected state when a new country is selected
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
                      // if (selectedCountry != null)
                       if (selectedCountry != null) ...[
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
                                  value: selectedState,
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
                      ] else ...[
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
                                  value: selectedState,
                                  hint: const Text('First select a country'),
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  onChanged: null,
                                  items: null,
                                ),
                          ),
                        ),   
                      ],
                       
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
                                  value: selectedCity,
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
                            Checkbox(
                              value: isMarriedChecked,
                              activeColor: Colors.orangeAccent, 
                              //it shows null value
                              // tristate: true,
                              onChanged: (newMarriedValue){ 
                                  setState(() {
                                      isMarriedChecked = newMarriedValue ?? false;
                                      if(isMarriedChecked = true){
                                        isUnMarriedChecked = false;
                                      }
                                      print(isMarriedChecked);
                                    });
                              }
                              ),
                             const SizedBox(width: 20.0,),
                              const Text("Married"),
                          ],
                          )
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
                        onPressed: () {
                          //validate return true if the form is valid, other wise false.
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              name = nameController.text;
                              email = emailController.text;
                              password = passwordController.text;
                              date_of_birth = dateOfBirthController.text;
                              addUser();
                              clearText();
                            });
                          }
                        },
                        child: const Text("Register"),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          clearText();
                        },
                        child: Text("Reset"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )));
  }
}
