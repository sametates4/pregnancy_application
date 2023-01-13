import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:num_remap/num_remap.dart';
import 'package:pregnancy_application/widget/progress_bar/progress_bar.dart';

import '../../../service/strings.dart';
import '../../chat_view/chat_view.dart';
import '../../../widget/chart_to_run/chartToRun.dart';

class BuildPatient extends StatelessWidget {
  const BuildPatient({Key? key, required this.user}) : super(key: key);
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var newIndex = snapshot.data!.docs[index];
                    if (newIndex.id == user!.uid) {
                      List list = newIndex['hemogram'];
                      Map<int, dynamic> map = list.asMap().cast<int, dynamic>();
                      List<double> newList = [];
                      List<String> label = [];
                      double value = 0.0;
                      double week = 0.0;
                      double newWeekly = 0.0;
                      int tag = 0;
                      if (newIndex['day'] == "") {
                      } else {
                        var date = DateTime(
                            int.parse(newIndex['year'].toString()),
                            int.parse(newIndex['month'].toString()),
                            int.parse(newIndex['day'].toString()));
                        var finishDate = date.difference(DateTime.now());
                        print(finishDate);
                        var val = 288 - finishDate.inHours / 24;
                        value = val.remap(0, 288, 0, 1);
                      }
                      if(newIndex['weekly'] == ""){

                      }else{
                        tag = int.parse(newIndex['weeklyTag'].toString());
                        week = double.parse(newIndex['weekly'].toString());
                        newWeekly = week / tag;
                      }
                      map.forEach((k, v) {
                        newList.add(double.parse(v.toString()));
                        label.add('${k + 1}');
                      });
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ProgressBar(
                                    value: double.parse(newIndex['daily']),
                                    text: daily),
                                ProgressBar(value: newWeekly, text: weekly),
                                ProgressBar(value: value, text: baby),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color.fromRGBO(235, 226, 223, 1),)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '$medicine: ${newIndex['medicine']}',
                                      style: const TextStyle(fontSize: 18),
                                    ),),
                                  Expanded(
                                    child: Text(
                                      '$exercise: ${newIndex['exercise']}',
                                      style: const TextStyle(fontSize: 18),
                                    ),),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Container(
                            width: double.infinity,
                            height: 250,
                            child: Column(
                              children: [
                                const Text(
                                  questions,
                                  style: TextStyle(fontSize: 18),
                                ),
                                Expanded(
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: buttons.length,
                                      itemBuilder: (context, index) {
                                        return ElevatedButton(
                                          onPressed: newIndex['days'] == '${DateTime.now().day}'
                                              ? null
                                              : () {
                                            switch (index) {
                                              case 0:
                                                healt(0.25, week, tag);
                                                break;
                                              case 1:
                                                healt(0.50, week, tag);
                                                break;
                                              case 2:
                                                healt(0.75, week, tag);
                                                break;
                                              case 3:
                                                healt(1, week, tag);
                                                break;
                                            }
                                          },
                                          child: Text(buttons[index]),
                                        );
                                      },
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 180,
                            child: ChartToRun(data: [newList], label: label),
                          ),

                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

void healt(double val, double week, int tag) async {
  double newVal = week + val;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    'days': '${DateTime.now().day}',
    'daily': '$val',
    'weekly': newVal,
    'weeklyTag': tag + 1
  });
}
