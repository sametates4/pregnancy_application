import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_application/service/provider/user_type_model/user_type_model.dart';
import 'package:pregnancy_application/views/home_view/components/drawer.dart';
import 'package:pregnancy_application/views/home_view/components/patient.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/strings.dart';
import '../chat_view/chat_view.dart';
import 'components/doctor.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  User? user = FirebaseAuth.instance.currentUser;
  final _date = TextEditingController();
  String year = "";
  String month = "";
  String day = "";
  double value = 0.0;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user!.uid).get();
      bool val = FirebaseAuth.instance.currentUser!.emailVerified;
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
      if(doc.docs[0]['user_type'].toString() == patient){
        final pref = await SharedPreferences.getInstance();
        if(pref.getString('day') == null){
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Tarih Seçiniz'),
                content: TextField(
                  controller: _date,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.date_range,),
                        onPressed: (){
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2050)).then((value){
                            var time = value!.add(const Duration(days: 288));
                            _date.text = '${value.day}-${value.month}-${value.year}';
                            FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
                              'day': time.day.toString(),
                              'year': time.year.toString(),
                              'month': time.month.toString(),
                            });
                          });
                        },
                      )
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text(ok),
                    onPressed: (){
                      pref.setString('day', '1');
                      Navigator.pop(context);
                    },
                  )
                ],
              )
          );
        }
      }
      write(doc.docs[0]['user_type'].toString());
    });
    super.initState();
  }

  void write(String val){
    context.read<UserTypeModel>().valChange(val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.watch<UserTypeModel>().valRead() == patient ? AppBar(
        title: const Text(home),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatView(id: user!.uid, name: 'Doctor')));
            },
          )
        ],
      ) : AppBar(
        title: const Text(home),
      ),
      drawer: const BuildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: context.watch<UserTypeModel>().valRead() == patient
            ? BuildPatient(user: user,)
            : const BuildDoctor()
      ),
    );
  }

}