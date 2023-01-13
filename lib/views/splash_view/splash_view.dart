import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_application/views/auth_view/auth_view.dart';
import 'package:pregnancy_application/views/home_view/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then((value){
      FirebaseAuth.instance.currentUser != null
          ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()))
          : Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthView()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Image.asset('assets/images/im6.jpeg'),
        )),
      ),
    );
  }
}
