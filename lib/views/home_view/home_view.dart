import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_application/views/home_view/components/drawer.dart';

import '../../service/strings.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bool val = FirebaseAuth.instance.currentUser!.emailVerified;
      print(val);
      if(val == false){
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            ),
            builder: (context){
              return Container(
                width: double.infinity,
                height: 100,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))
                ),
                child: const Center(child: Text(verifyEmail),),
              );
            }
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(home),),
      drawer: const BuildDrawer(),
      body: Column(
        children: [
          Center(child: Text('e posta doğrulama: ${FirebaseAuth.instance.currentUser!.emailVerified}'),),
        ],
      ),
    );
  }
}
