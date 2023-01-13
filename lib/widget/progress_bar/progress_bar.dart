import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key, required this.value, required this.text}) : super(key: key);
  final double value;
  final String text;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.3,
      height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, textAlign: TextAlign.center,),
            const SizedBox(height: 5,),
            CircularProgressIndicator(
              value: value,
              color: Colors.black,
              backgroundColor: const Color.fromRGBO(235, 226, 223, 1),
            )
          ],
        )
    );
  }
}
