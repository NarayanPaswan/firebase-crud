import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/home/home_view.dart';
import 'app_routes_name.dart';
import 'app_routes_path.dart';

class AppRouter{
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
          name: RouteNames.login,
          path: RoutesPath.login,
          pageBuilder: (context, state){
            return const MaterialPage(child: LoginView());
          },
      ),
      GoRoute(
          name: RouteNames.home,
          // path: RoutesPath.home,
          path: '/home/:username/:userid',
          pageBuilder: (context, state){
            return MaterialPage(child: HomeView(
              username: state.params['username']!,
              userid: state.params['userid']!,
            ));
          },
      ),
       GoRoute(
          name: RouteNames.register,
          path: RoutesPath.register,
          pageBuilder: (context, state){
            return const MaterialPage(child: RegisterView());
          },
      ),
    ],

    redirect: (context, state){
      
    }
    
    );
}