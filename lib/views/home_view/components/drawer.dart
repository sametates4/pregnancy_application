import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_application/service/strings.dart';
import 'package:pregnancy_application/views/auth_view/auth_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
            accountEmail: Text(FirebaseAuth.instance.currentUser!.email.toString()),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(250, 228, 218, 1),
            ),
          ),
          const Spacer(),
          ListTile(
            title: const Text(exit),
            leading: const Icon(Icons.exit_to_app, color: Colors.black,),
            onTap: ()async{
              final pref = await SharedPreferences.getInstance();
              pref.remove('day');
              pref.clear();
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthView()));
            },
          ),
        ],
      ),
    );
  }
}
