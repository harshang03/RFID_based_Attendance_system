import 'dart:ui';

import 'package:flutter/material.dart';

class ListCategoriesForPieChart extends StatelessWidget {
  const ListCategoriesForPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.green),
              child: Center(
                child: Text(
                  '1',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Present',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.red),
              child: Center(
                child: Text(
                  '1',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Absent',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
