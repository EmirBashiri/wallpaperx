import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/root.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  // Root Screen bottom navigation
  RestorableInt navigationIndex = RestorableInt(homeScreenIndex);
  final GlobalKey<ScaffoldState> rootNavigatorKey = GlobalKey();

  // Root functions
  late final RootFunctions rootFunctions =
      RootFunctions(restorableInt: navigationIndex, navigationController: this);
}
