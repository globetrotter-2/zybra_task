

import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_ce/hive.dart';
import 'package:zybratask/extensions/space_exs.dart';
import 'package:zybratask/utils/app_colors.dart';
import 'package:zybratask/utils/app_str.dart';
import 'package:zybratask/views/home/components/fab.dart';

import '../../main.dart';
import '../../models/task.dart';
import '../../utils/constants.dart';
import 'components/home_app_bar.dart';
import 'components/slider_drawer.dart';
import 'widget/task_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key,
    required TextEditingController titleTaskController,
    required TextEditingController descriptionTaskController, required task});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  get titleTaskController => null;

  get descriptionTaskController => null;


  /// Check value of circle Indicator
  dynamic valueOfIndicator (List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  /// check done Tasks
  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks) {
      if (doneTask.isCompleted) {

      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
      valueListenable: base.dataStore.listentoTask(),
      builder: (ctx, Box<Task>box,Widget ? child) {
        var tasks = box.values.toList();
        /// for sorting list
        tasks.sort((a,b) =>a.createdAtDate.compareTo(b.createdAtDate));

      return Scaffold(
        backgroundColor: Colors.white,

        /// FAB
        floatingActionButton: Fab(),

        /// Body
        body: SliderDrawer(
          key: drawerKey,
          isDraggable: false,
          animationDuration: 1000,

          /// Drawer
          slider: CustomDrawer(),

          appBar: HomeAppBar(
            drawerKey: drawerKey,
          ),

          /// Main body
          child: _buildHomeBody(textTheme, base, tasks),
        ),
      );

    }
    );
  }

  /// Home body
  Widget _buildHomeBody(
      TextTheme textTheme,
      BaseWidget base,
      List<Task> tasks
      ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [

          ///custom App bar
          Container(
            margin: const EdgeInsets.only(top: 60),
            width: double.infinity,
            height: 100,
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// Progress Indicator
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation(
                        AppColors.primaryColor
                    ),
                  ),
                ),

                /// space
                25.w,

                /// top level Task info
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStr.mainTitle,
                      style: textTheme.displayLarge,
                    ),
                    3.h,
                    Text(
                      "${checkDoneTask(tasks)} of ${tasks.length} tasks}",
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),


              ],
            ),

          ),

          ///Divider
          const Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),

          /// Tasks
          SizedBox(
            width: double.infinity,
            height: 500,
            child: tasks.isNotEmpty

            /// Task list is not expty
                ? ListView.builder(
                itemCount: tasks.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var task = tasks[index];
                  return Dismissible(
                      direction: DismissDirection.horizontal,
                      onDismissed: (_) {
                      base.dataStore.deleteTask(task: task);
                      },
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.grey,
                          ),
                          8.w,
                          const Text(AppStr.deleteTask,
                            style: TextStyle(
                                color: Colors.grey
                            ),

                          )
                        ],
                      ),
                      key: Key(task.id),
                      child: TaskWidget( task: task ),
                  );
                })

            /// Task list is expty
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// Lottie Anime
                FadeIn(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      lottieURL,
                      animate: tasks.isNotEmpty ? false : true,
                    ),
                  ),
                ),

                /// sub Text
                FadeInUp(
                    from: 30,
                    child: const Text(
                      AppStr.doneAllTask,
                    ))
              ],
            ),
          ),
        ],
      ),

    );
  }
  }

