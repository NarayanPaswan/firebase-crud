import '../../routes/app_routes_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes_name.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Column(
        children: [
           const Text("Login Page"),
           const SizedBox(height: 10,),
           ElevatedButton(onPressed: (){
            GoRouter.of(context).pushNamed(
              RouteNames.home,
              params: {'username':'narayan', 'userid':'98323399'},
              
              
              );
           }, 
           child: const Text("Home")),

           const SizedBox(height: 10,),
           ElevatedButton(onPressed: (){}, child: const Text("Register")),
        ],
      ),
    );
  }
}