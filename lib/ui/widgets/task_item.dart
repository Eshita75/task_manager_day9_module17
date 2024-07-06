import 'package:flutter/material.dart';
import 'package:task_manager_day9_module17/data/models/task_model.dart';
import 'package:task_manager_day9_module17/ui/widgets/show_snack_bar_message.dart';

import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';
import 'centered_progress_indicator.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key, required this.taskModel, required this.onUpdateTask,
  });

  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteInProgress = false;
  bool _editInProgress = false;
  String dropdownValue = '';
  List<String> statusList = [
    'New',
    'Progress',
    'Completed',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.taskModel.status!;
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        title: Text(widget.taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(widget.taskModel.description ?? ''),
             Text(
              'Date: ${widget.taskModel.createdDate} ',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  //backgroundColor: Colors.blue,
                  label:  Text(widget.taskModel.status ?? 'New'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),),
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                ),

                const Spacer(),

                ButtonBar(
                  children: [
                    Visibility(
                      visible: _deleteInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: IconButton(onPressed: (){
                        _deleteTask();
                      }, icon: const Icon(Icons.delete)),
                    ),


                    Visibility(
                      visible: _editInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.edit),
                        onSelected: (String selectedValue) {
                          dropdownValue = selectedValue;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return statusList.map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child: ListTile(
                                title: Text(value),
                                trailing: dropdownValue == value
                                    ? const Icon(Icons.done)
                                    : null,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    _deleteInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.deleteTask(widget.taskModel.sId!));
    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Get task count by status failed! Try again',
        );
      }
    }
    _deleteInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }



  Future<void> _updateTask() async {
    _editInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.updateTaskStatus(widget.taskModel.sId!, widget.taskModel.status!));
    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Get task count by status failed! Try again',
        );
      }
    }
    _editInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}

