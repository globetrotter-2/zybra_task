import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/task.dart';
import '../../../utils/app_colors.dart';
import '../../tasks/task_view.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    Key? key,
    required this.task,
  }): super(key: key);
  final Task task;
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController textEditingControllerForTitle = TextEditingController();
  TextEditingController textEditingControllerForSubTitle = TextEditingController();

  @override
  void initState() {
    textEditingControllerForTitle.text = widget.task.title;
    textEditingControllerForSubTitle.text = widget.task.subTitle;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerForTitle.dispose();
    textEditingControllerForSubTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      Navigator.push(
          context,
          CupertinoPageRoute(builder:(ctx) => TaskView(
         titleTaskController: textEditingControllerForTitle,
         descriptionTaskController: textEditingControllerForSubTitle,
         task: widget.task,
       )
       )
      );
      },

      /// Main card
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(
          horizontal: 16, vertical: 8,),
        decoration: BoxDecoration(
            color:
                widget.task.isCompleted ?
            AppColors.primaryColor.withOpacity(0.1)
                    : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                offset: Offset(0, 4),
                blurRadius: 10,),
            ]),
        duration: const Duration(milliseconds: 600),
        child: ListTile(

          ///check icon
          leading: GestureDetector(
            onTap: () {
              widget.task.isCompleted = !widget.task.isCompleted;
              widget.task.save();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              decoration: BoxDecoration(
                  color:
                      widget.task.isCompleted?
                  AppColors.primaryColor
                      :Colors.white,
                  shape: BoxShape.circle,
                  border:
                  Border.all(color: Colors.grey, width: .8)
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),


          ///Task title
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 3),
            child: Text(
              textEditingControllerForTitle.text,
              style: TextStyle(
                color:widget.task.isCompleted
                    ? AppColors.primaryColor :
                Colors.black,
                fontWeight: FontWeight.w500,
               decoration: widget.task.isCompleted?
                   TextDecoration.lineThrough
                   :null,
              ),
            ),
          ),


          ///
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Task Description
              Text(
                textEditingControllerForSubTitle.text,
                style: TextStyle(
                  color:widget.task.isCompleted
                      ? AppColors.primaryColor :
                  Colors.black,
                  fontWeight: FontWeight.w300,
                  decoration: widget.task.isCompleted?
                  TextDecoration.lineThrough
                      :null,
                ),
              ),

              /// Date of task
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('hh:mm a')
                    .format(widget.task.createdAtTime),
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.task.isCompleted
                            ? Colors.white
                              :  Colors.grey
                        ),
                      ),
                      Text(
                        DateFormat.yMMMEd()
                            .format(widget.task.createdAtDate),
                        style: TextStyle(
                            fontSize: 14,
                            color: widget.task.isCompleted
                                ? Colors.white
                                :  Colors.grey
                        ),
                      ),

                    ],
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
