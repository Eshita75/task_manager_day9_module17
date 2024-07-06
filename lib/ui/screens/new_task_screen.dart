import 'package:flutter/material.dart';
import 'package:task_manager_day9_module17/data/models/network_response.dart';
import 'package:task_manager_day9_module17/data/models/task_count_by_status_wrapper_model.dart';
import 'package:task_manager_day9_module17/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_day9_module17/data/network_caller/network_caller.dart';
import 'package:task_manager_day9_module17/data/utility/urls.dart';
import 'package:task_manager_day9_module17/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_day9_module17/ui/utility/app_colors.dart';
import 'package:task_manager_day9_module17/ui/widgets/centered_progress_indicator.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../widgets/show_snack_bar_message.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTasksInProgress = false;
  bool _getTaskCountByStatusInProgress = false;
  List<TaskModel> newTaskList = [];
  List<TaskCountByStatusModel> taskCountByStatusList = [];


  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Column(
          children: [
            _buildSummarySection(),
            const SizedBox(
              height: 8,
            ),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _getNewTasks();
                    _getTaskCountByStatus();
                  },
                  child: Visibility(
                    visible: _getNewTasksInProgress == false,
                    replacement: const CenteredProgressIndicator(),
                    child: ListView.builder(
                  itemCount: newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskItem(
                      taskModel: newTaskList[index],
                      onUpdateTask: () {
                        _getTaskCountByStatus();
                        _getNewTasks();
                      },
                    );
                  },
                ),
              ),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton,
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  _onTapAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddNewTaskScreen();
        },
      ),
    );
  }

  Widget _buildSummarySection() {
    return Visibility(
      visible: _getTaskCountByStatusInProgress == false,
      replacement: const SizedBox(
        height: 100,
        child: CenteredProgressIndicator(),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: taskCountByStatusList.map((e) {
            return TaskSummaryCard(
              title: (e.sId ?? 'Unknown').toUpperCase(),
              count: e.sum.toString(),
            );
          }).toList(),
        ),
      ),
    );
  }


  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
      TaskCountByStatusWrapperModel.fromJson(response.responseData);
      taskCountByStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Get task count by status failed! Try again',
        );
      }
    }
    _getTaskCountByStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }



  Future<void> _getNewTasks() async{
    _getNewTasksInProgress = true;
    if(mounted){
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);

    if(response.isSuccess){
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];
    }else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Get new task failed! Try again');
      }
    }
    _getNewTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}