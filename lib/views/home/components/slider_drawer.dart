import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zybratask/extensions/space_exs.dart';
import 'package:zybratask/utils/app_colors.dart';
class CustomDrawer extends StatelessWidget {
   CustomDrawer({super.key});

  ///Icons
  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Text
  final List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];
  
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: AppColors.primaryGradientColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
         const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://ca-times.brightspotcdn.com/dims4/default/76311f0/2147483647/strip/true/crop/4121x2747+0+0/resize/1200x800!/quality/75/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F94%2F82%2F30aea31e4b189678e4b7d3ff0e34%2Fet-shah-rukh-khan-gettyimages-060.JPG"
            ),
          ),
          8.h,
          Text("Globetrotter" , style: textTheme.displayMedium,),
          Text("Mobile FullStack" , style: textTheme.displaySmall,),

          Container(
            margin:const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 10,
            ),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              itemCount: icons.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                onTap: (){
                  log('${texts[index]} Item Tapped!' as num);
                },
                  child:Container(
                  margin:const EdgeInsets.all(3),
                  child: ListTile(
                    leading: Icon(
                        icons[index],
                      color: Colors.white,
                      size: 30,
                    ),
                    title: Text(
                        texts[index],
                      style: const TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                );
              }
            ),
          ),
          
        ],
      ),
    );
  }
}
