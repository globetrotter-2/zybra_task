import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:zybratask/utils/constants.dart';

import '../../../main.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.drawerKey});

  final GlobalKey<SliderDrawerState>drawerKey;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> with SingleTickerProviderStateMixin{
  late AnimationController animateController;
  bool isDrawerOpen = false;
  @override
  void initState(){
    animateController = AnimationController(vsync: this,
      duration: const Duration(seconds: 1)
    );
    super.initState();
  }
  @override
  void dispose(){
    animateController.dispose();
    super.dispose();
  }

  /// onToggle
  void onDrawerToggle(){
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if(isDrawerOpen)
      {
        animateController.forward();
        widget.drawerKey.currentState!.openSlider();
      }
      else{
        animateController.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            /// Menu icon
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                  onPressed: onDrawerToggle,
                  icon: AnimatedIcon(
                      icon:AnimatedIcons.menu_close,
                      progress: animateController,
                    size: 40,
                  ),
              ),
            ),

            /// Trash icon
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {
                  base.isEmpty
                      ? noTaskWarning(context)
                  : deleteAllTask(context);
                },
                icon: const Icon(
                  CupertinoIcons.trash_fill,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
