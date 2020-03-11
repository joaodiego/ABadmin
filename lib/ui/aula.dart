import 'package:flutter/material.dart';

class Aula extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
       Card(
        elevation: 5,
        color: Colors.white,
        borderOnForeground: true,
        child: Center(
          child:Text('Agende sua Aula'),
        ),
     )
    );
  }
}
