import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallpaper_x/Model/Themes/Colors/colors.dart';
import 'package:flutter_wallpaper_x/Model/Themes/TextStyle/text_style.dart';

class CustomThemes {
  final CustomColors customColors;
  final CustomTextStyle customTextStyle;

  CustomThemes({required this.customColors, required this.customTextStyle});

  ThemeData get defaultLightTheme => ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: customColors.backgroundLight,
              statusBarColor: customColors.backgroundLight,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark),
        ),
        brightness: Brightness.light,
        textTheme: customTextStyle.textTheme,
        colorScheme: ColorScheme.light(
          onSurface: customColors.whitColor,
          brightness: Brightness.light,
          primary: customColors.primary,
          background: customColors.backgroundLight,
          secondary: customColors.secondaryLight,
          shadow: customColors.secondaryLight.withOpacity(0.5),
          tertiary: customColors.blueLinkColor,
        ),
      );

  ThemeData get defaultDarkTheme => ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: customColors.backgroundDark,
            statusBarColor: customColors.backgroundDark,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        brightness: Brightness.dark,
        textTheme: customTextStyle.textTheme,
        colorScheme: ColorScheme.dark(
          brightness: Brightness.dark,
          onSurface: customColors.whitColor,
          primary: customColors.primary,
          background: customColors.backgroundDark,
          secondary: customColors.secondaryDark,
          shadow: customColors.secondaryDark.withOpacity(0.5),
          tertiary: customColors.blueLinkColor,
        ),
      );
}
