import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/initial_controller.dart';
import 'package:flutter_wallpaper_x/Model/Themes/themes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeFunctions {
  final String themePreferences = "Themepreferences";

  Future<void> setTheme(
      {required CustomThemeMode themeMode,
      required ThemeData themeData,
      required InitialController initialController}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    initialController.applicationTheme.value = themeData;
    await sharedPreferences.setString(themePreferences, themeMode.name);
  }

  Future<ThemeData> getTheme() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String? savedTheme = sharedPreferences.getString(themePreferences);
    final InitialController initialController = Get.find();
    if (savedTheme != null) {
      final CustomThemeMode customThemeMode = CustomThemeMode.values
          .firstWhere((element) => element.name == savedTheme);
      final CustomThemes customThemes = initialController.customThemes;
      switch (customThemeMode) {
        case CustomThemeMode.systemDefault:
          return initialController.initialTheme;
        case CustomThemeMode.defaultDark:
          return customThemes.defaultDarkTheme;
        case CustomThemeMode.defaultLight:
          return customThemes.defaultLightTheme;
      }
    } else {
      return initialController.initialTheme;
    }
  }

  Future<CustomThemeMode> getThemeMode() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String? savedTheme = sharedPreferences.getString(themePreferences);
    if (savedTheme != null) {
      final CustomThemeMode customThemeMode = CustomThemeMode.values
          .firstWhere((element) => element.name == savedTheme);
      switch (customThemeMode) {
        case CustomThemeMode.systemDefault:
          return CustomThemeMode.systemDefault;
        case CustomThemeMode.defaultDark:
          return CustomThemeMode.defaultDark;
        case CustomThemeMode.defaultLight:
          return CustomThemeMode.defaultLight;
      }
    } else {
      return CustomThemeMode.systemDefault;
    }
  }
}
