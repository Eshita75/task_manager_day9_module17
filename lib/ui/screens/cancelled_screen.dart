import 'package:flutter/material.dart';

import '../widgets/profile_appbar.dart';
import '../widgets/task_item.dart';

class CancelledScreen extends StatefulWidget {
  const CancelledScreen({super.key});

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
          child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index){
                //return TaskItem();
              })
      ),
    );
  }
}
