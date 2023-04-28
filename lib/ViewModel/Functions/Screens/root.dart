import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/navigation_controller.dart';
import 'package:flutter_wallpaper_x/View/SearchScreen/search_screen.dart';
import 'package:get/get.dart';

class RootFunctions {
  final RestorableInt restorableInt;
  final BottomNavigationController navigationController;
  bool isBottomSheetOpen = false;
  List<int> lastScreen = [];

  RootFunctions(
      {required this.restorableInt, required this.navigationController});
//  this function call for update screen and screen list whenever bottom sheet closed
  void bottomSheetClosed() {
    lastScreen.removeLast();
    restorableInt.value = lastScreen.last;
    navigationController.update();
    isBottomSheetOpen = false;
    Get.find<DuplicateController>().searchTextController.value.text = "";
  }

// this function call for open bottom sheet
  void openMottomSheet({required int value, required Color backgroundColor}) {
    isBottomSheetOpen = true;
    final currentState = navigationController.rootNavigatorKey.currentState;
    if (currentState != null) {
      currentState
          .showBottomSheet(
            backgroundColor: backgroundColor,
            shape: bottomSheetShape,
            (context) => const SearchScreen(),
          )
          .closed
          .then(
        (element) {
          bottomSheetClosed();
        },
      );
    }
  }

// this function call for close  bottom navigation
  void closeBottomSheet() {
    Get.back();
  }

// this function call whenever user tap on bottom navigation item
  void bottomNavigationTap(
      {required int value,
      required PageController pageController,
      required Color backgroundColor}) {
    restorableInt.value = value;
    navigationController.update();
    lastScreen.removeWhere((element) => element == value);
    lastScreen.add(value);
    if (value == searchScreenIndex) {
      if (isBottomSheetOpen) {
        closeBottomSheet();
      } else {
        openMottomSheet(value: value, backgroundColor: backgroundColor);
      }
    } else {
      pageController.jumpToPage(value);
    }
  }
}
