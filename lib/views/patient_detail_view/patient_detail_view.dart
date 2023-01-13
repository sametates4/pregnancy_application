import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:num_remap/num_remap.dart';
import 'package:pregnancy_application/service/strings.dart';
import 'package:pregnancy_application/views/chat_view/chat_view.dart';

import '../../widget/chart_to_run/chartToRun.dart';
import '../../widget/progress_bar/progress_bar.dart';

class PatientDetailView extends StatefulWidget {
  const PatientDetailView({Key? key, required this.doc}) : super(key: key);
  final DocumentSnapshot doc;
  @override
  State<PatientDetailView> createState() => _PatientDetailViewState();
}

class _PatientDetailViewState extends State<PatientDetailView> {

  final _medicine = TextEditingController();
  final _exercise = TextEditingController();
  final _hemogram = TextEditingController();

  List<double> newList = [];
  List<String> label = [];
  double value = 0.0;
  double newWeekly = 0.0;


  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData(){
    _exercise.text = widget.doc['exercise'];
    _medicine.text = widget.doc['medicine'];
    List list = widget.doc['hemogram'];
    Map<int, dynamic> map = list.asMap().cast<int, dynamic>();
    if (widget.doc['day'] == "") {
    } else {
      var date = DateTime(
          int.parse(widget.doc['year'].toString()),
          int.parse(widget.doc['month'].toString()),
          int.parse(widget.doc['day'].toString()));
      var finishDate = date.difference(DateTime.now());
      var val = 288 - finishDate.inHours / 24;
      value = val.remap(0, 288, 0, 1);
    }
    int tag = int.parse(widget.doc['weeklyTag'].toString());
    double week = double.parse(widget.doc['weekly'].toString());
    newWeekly = week / tag;
    map.forEach((k, v) {
      newList.add(double.parse(v.toString()));
      label.add('${k + 1}');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => ChatView(id: widget.doc.id, name: widget.doc['name'])));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _medicine,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: medicine,
                ),
              ),
              const SizedBox(height: 8,),
              TextField(
                controller: _exercise,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: exercise,
                ),
              ),
              const SizedBox(height: 8,),
              TextField(
                controller: _hemogram,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: hemogram,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProgressBar(value: double.parse(widget.doc['daily']), text: daily),
                    ProgressBar(value: newWeekly, text: weekly),
                    ProgressBar(value: value, text: baby),
                  ],
                ),
              ),
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
                          '$medicine: ${widget.doc['medicine']}',
                          style: const TextStyle(fontSize: 18),
                        ),),
                      Expanded(
                        child: Text(
                          '$exercise: ${widget.doc['exercise']}',
                          style: const TextStyle(fontSize: 18),
                        ),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 180,
                child: ChartToRun(data: [newList], label: label),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.update),
        onPressed: ()async{
          List list = widget.doc['hemogram'];
          list.add(_hemogram.text);
          await FirebaseFirestore.instance.collection('users').doc(widget.doc.id).update({
            'medicine': _medicine.text,
            'exercise': _exercise.text,
            'hemogram': list,
          });
          _hemogram.clear();
          _exercise.clear();
          _medicine.clear();
        },
      ),
    );
  }
}
