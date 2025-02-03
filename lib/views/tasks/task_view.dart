import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:zybratask/extensions/space_exs.dart';
import 'package:zybratask/main.dart';
import 'package:zybratask/models/task.dart';
import 'package:zybratask/utils/app_colors.dart';
import 'package:zybratask/utils/app_str.dart';
import 'package:zybratask/utils/constants.dart';

import '../home/components/date_time_selection.dart';
import '../home/components/rep_textfield.dart';
import '../home/widget/task_view_app_bar.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.titleTaskController,
    required  this.descriptionTaskController,
    required  this.task
  });

  final TextEditingController ? titleTaskController;
  final TextEditingController ? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;

  DateTime? time;
  DateTime? date;

  /// Show selected time as String format
  String showTime(DateTime? time){
    if(widget.task?.createdAtTime == null){
      if(time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();

    }
  }

  /// Show selected time as String format
  String showDate(DateTime? date){
    if (widget.task?.createdAtDate == null){
      if(date == null) {
        return DateFormat.yMMMEd()
            .format(DateTime.now())
            .toString();
      } else {
        return DateFormat.yMMMEd()
            .format(date).toString();
      }
      } else {
      return DateFormat.yMMMEd()
          .format(widget.task!.createdAtDate)
          .toString();
    }
  }

  /// show selected Date as Date format for init Time
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if(date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }


  ///  if any Task Already Exist return true otherwise false
  bool isTaskAlreadyExist(){
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null){
      return true;
    }else {
      return false;
    }
  }

  /// Main function for creating or updating tasks
  dynamic isTaskAlreadyExistUpdateOtherWiseCreate(){


    /// HERE WE UPDATE CURRENT TASK
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text == null){
      try {
        widget.titleTaskController ?.text = title;
        widget.descriptionTaskController?.text = subTitle;
        widget.task?.save();

        Navigator.pop (context);
      } catch (e){
        /// if user want to update task but entered nothing we will show this warning
        updateTaskWarning(context);
      }
      /// here we create a new task
    }else {
      if (title != null && subTitle != null) {
        var task = Task.create(
            title: title,
            subTitle: subTitle,
            createdAtTime: time,
            createdAtDate: date,
            );
        /// we are adding this new task to HIve DB using inherited widget
        BaseWidget.of(context).dataStore.addTask(task: task);

        Navigator.pop (context);
      } else {
        /// warning
        emptyWarning(context);
      }
    }
  }

  ///Delete Task
  dynamic deleteTask() {
    return widget.task?.delete();
  }



  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),

      child: Scaffold(


        /// Appbar
        appBar: const TaskViewAppBar(),

        /// Body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [

                /// Top Side Texts
                _buildTopSideTexts(textTheme),

                /// Main Task view activity
                _buildMainTaskViewActivity(
                    textTheme,
                    context
                ),
                /// Bottom side buttons
                _buildBottomSideButtons()

          ],
                  ),
                ),
            ),
          ),
    );
  }
  /// Bottom side buttons
  Widget _buildBottomSideButtons(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExist()
        ? MainAxisAlignment.center
        : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExist()
          ? Container()
          :
          /// Delete current TAsk
          MaterialButton(
            onPressed: () {
              deleteTask();
              Navigator.pop(context);
            },
            minWidth: 150,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 55,
            child: Row(
              children: [
                const Icon(
                  Icons.close,
                  color: AppColors.primaryColor,
                ),
                const Text(
                  AppStr.deleteTask,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          /// Add or Update task
          MaterialButton(
            onPressed: () {
             isTaskAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 55,
            child:  Text(
             isTaskAlreadyExist()
              ? AppStr.addTaskString
             : AppStr.updateTaskString,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

 /// Main Task view activity
  Widget _buildMainTaskViewActivity(
      TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Title of Textfield
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleofTitleTextField,
              style: textTheme.headlineMedium,),
          ),

          /// Task Title
          RepTextField(
            Controller: widget.titleTaskController,
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
            onFieldSubmitted: (String inputTitle){
              title = inputTitle;
            }, controller: null ,
          ),
          10.h,

          /// Task Title

          RepTextField(
            Controller: widget.descriptionTaskController,
            isForDescription: true,
            onChanged:(String inputSubTitle) {
              subTitle = inputSubTitle;
            },
            onFieldSubmitted:(String inputSubTitle) {
              subTitle = inputSubTitle;
            }, controller: null,
          ),

          /// Time selection
          DateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) =>
                    SizedBox(
                      height: 200,
                      child: TimePickerWidget(
                      initDateTime: showDateAsDateTime(time),
                        dateFormat: 'HH:mm',
                        onChange: (_, __) {},
                        onConfirm: (dateTime, _) {
                          setState(() {
                            if (widget.task?.createdAtTime ==null) {
                              time = dateTime;
                            } else {
                              widget.task!.createdAtTime = dateTime;
                            }
                          });
                        },
                      ),
                    ),
              );
            },
            title: AppStr.timeString,

            /// For Testing

            time: showTime(time),
          ),

          /// Date selection
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(
                  context,
                  maxDateTime: DateTime(2030, 4, 5),
                  minDateTime: DateTime.now(),
                  initialDateTime: showDateAsDateTime(date),
                  onConfirm: (dateTime, _) {
                    setState(() {
                      if (widget.task?.createdAtDate ==null) {
                        date = dateTime;
                      } else {
                        widget.task!.createdAtDate = dateTime;
                      }
                    });
                  }
              );
            },
            title: AppStr.dateString,

            isTime: true,

            time: showTime(date),
          ),

        ],
      ),
    );
  }
  /// Top side texts
  Widget _buildTopSideTexts(textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Divider - grey
            const SizedBox(
              width: 70,
              child: Divider(
                thickness: 2,
              ),
            ),

            /// Later on according to the tasks conditio n we
            /// will decide to "ADD NEW TASK" or "UPDATE CURRENT"
            /// task
            RichText(
                text: TextSpan(
                  text: isTaskAlreadyExist()
                  ? AppStr.addNewTask
                  : AppStr.UpdateCurrentTask,
                  style: textTheme.titleLarge,
                  children: const [
                    TextSpan(text: AppStr.taskString,
                      style: TextStyle(fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )),
            /// Divider - grey
            const SizedBox(
              width: 70,
              child: Divider(
                thickness: 2,
              ),
            ),
          ]
      ),
    );
  }
}


