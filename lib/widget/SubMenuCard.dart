import 'package:flutter/material.dart';

class SubMenuCard extends StatelessWidget {
  final double width;
  final String text;

  const SubMenuCard({
    Key? key,
    required this.width,
    this.text: '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          height: width * 10,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
