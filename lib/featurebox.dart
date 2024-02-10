import 'dart:html';

import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color; // Define a color property
  final String htext;
  final String descriptiontext;
  FeatureBox(
      {Key? key,
      required this.color,
      required this.htext,
      required this.descriptiontext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        width: 300,
        // height: 60,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(),
            color: color,
            borderRadius: BorderRadius.circular(
                10) // Use the color from the widget property
            ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                descriptiontext,
                style: TextStyle(
                    fontFamily: 'Cera Pro', fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              htext,
              style: TextStyle(fontFamily: 'Cera Pro'),
            ),
          ],
        ));
  }
}
