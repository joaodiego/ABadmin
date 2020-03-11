import 'package:flutter/material.dart';

class Guardaria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child:
        Card(
          elevation: 5,
          color: Colors.white,
          borderOnForeground: true,
          child: Center(
            child:Text('Guardaria'),
          ),
        )
    );
  }
}