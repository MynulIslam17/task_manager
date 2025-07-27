import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskCountSummaryCard extends StatelessWidget {

  final int count;
  final String title;


  const TaskCountSummaryCard({
    super.key,
    required this.title,
    required this.count
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
          child: Column(
            children: [
              Text("$count",style: TextTheme.of(context).titleLarge?.copyWith(fontWeight: FontWeight.bold),),
              Text(title)
            ],
          ),
        ),
      ),
    );
  }
}