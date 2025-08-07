import 'package:flutter/material.dart';
import 'package:weight_plate_manager/pages/email_login.dart';
import 'package:weight_plate_manager/pages/signup_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool showLogin = true;

  void togglePages(){
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLogin){
      return EmailLoginPage();
    }
    else{
      return SignupPage();
    }
  }
}