import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../main.dart';
import 'app_str.dart';

/// lottie asset address
String lottieURL = 'assets/lottie/1.json';


/// Empty Title or SubTitle TextField warning

dynamic emptyWarning(BuildContext context){
  return FToast.toast(
      context,
    msg: AppStr.oopsMsg,
    subMsg: 'you must fill all fields',
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

/// Nothing entered when user try to edit or update the current task

dynamic updateTaskWarning(BuildContext context){
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: "you must edit one tasks then try to update it!",
    corner: 20.0,
    duration: 5000,
    padding: const EdgeInsets.all(20),
  );
}

/// No task warning dialog for deleting
dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
      context,
    title: AppStr.oopsMsg,
    message:
      "There is no TAsk for Delete!\n Try adding some and then try to delete it!",
    buttonText: "Okay",
    onTapDismiss: (){
        Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

///Delete All Task From Db dialog
dynamic deleteAllTask(BuildContext context)   {
  return PanaraConfirmDialog.show(
    context,
    title: AppStr.areYouSure,
    message:("Do You really want to delete all tasks?You will no able to undo this action!"),
    confirmButtonText:'Yes',
    cancelButtonText: 'No',
    onTapConfirm: (){
      /// we will clear all box data using this command later on
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    onTapCancel: () {
      Navigator.pop(context);
  },
    panaraDialogType: PanaraDialogType.error, barrierDismissible: false,
  );
}


