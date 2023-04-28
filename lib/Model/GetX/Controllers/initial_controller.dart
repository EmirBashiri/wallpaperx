import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/Themes/Colors/colors.dart';
import 'package:flutter_wallpaper_x/Model/Themes/TextStyle/text_style.dart';
import 'package:flutter_wallpaper_x/Model/Themes/themes.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/LocalizationFunctions/localization.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/ThemeFunctions/theme.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InitialController extends GetxController {
  // Localization part
  final localizationsDelegates = AppLocalizations.localizationsDelegates;
  final supportedLocales = AppLocalizations.supportedLocales;
  final LocalizationFunctions localizationFunctions = LocalizationFunctions();
  final Locale initialLocale = Locale(Platform.localeName.split("_").first);
  late var applicationLocale = initialLocale.obs;

  // Multi theme part
  final CustomColors customColors = CustomColors();
  late CustomTextStyle customTextStyle = CustomTextStyle();
  late CustomThemes customThemes = CustomThemes(
      customColors: customColors, customTextStyle: customTextStyle);
  final ThemeFunctions themeFunctions = ThemeFunctions();
  final window = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first);
  late ThemeData initialTheme = window.platformBrightness == Brightness.light
      ? customThemes.defaultLightTheme
      : customThemes.defaultDarkTheme;
  late var applicationTheme = initialTheme.obs;

  // Restoration part

  // restoration scope Id
  String resorationScopeId = "WallpaperX";
  // root screen restoration id
  String rootScreenRestoration = "WallpaperX_Root_screen";
  // home screen restoration id
  String homeScreenRestoration = "WallpaperX_Home_screen";

  // Home screen initial tap index
  RestorableInt tapIndex = RestorableInt(homeScreenIndex);

  @override
  void onInit() async {
    applicationLocale.value = await localizationFunctions.getLocale();
    applicationTheme.value = await themeFunctions.getTheme();
    super.onInit();
  }
}
