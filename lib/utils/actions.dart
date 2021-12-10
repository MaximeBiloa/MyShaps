import 'package:flutter/material.dart';

class MayegeActions {
  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void popContext(BuildContext context) {
    Navigator.pop(context);
  }

  static void getRessourcesErrorToast(String text) {
    //BotToast.showText(text: text, align: Alignment.center);
    //BotToast.closeAllLoading();
  }

  static void internetErrorToast(String text) {
    /*BotToast.showText(
        text: text,
        align: Alignment.center);
    BotToast.closeAllLoading();*/
  }

  static void loginIdentifiantsError(String text) {
    //BotToast.showText(text: text, align: Alignment.center);
    //BotToast.closeAllLoading();
  }

  static void updateInfosError(String text) {
    /*BotToast.showText(
        text: 'Échec de la mise à jour, réessayez plus tard',
        align: Alignment.center);
    BotToast.closeAllLoading();*/
  }
}
