import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_application/service/strings.dart';
import 'package:pregnancy_application/views/auth_view/auth_view.dart';

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
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var newIndex = snapshot.data!.docs[index];
                      if(newIndex['user_type'] == patient){
                        return ListTile(
                          title: Text(newIndex['name']),
                          onTap: ()async{

                          },
                        );
                      }else{
                        return Container();
                      }
                    },
                  );
                }else{
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
          ListTile(
            title: const Text(exit),
            leading: const Icon(Icons.exit_to_app, color: Colors.black,),
            onTap: (){
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
