import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../service/strings.dart';
import '../../patient_detail_view/patient_detail_view.dart';

class BuildDoctor extends StatelessWidget {
  const BuildDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PatientDetailView(
                      doc: newIndex,
                    )));
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
    );
  }
}
