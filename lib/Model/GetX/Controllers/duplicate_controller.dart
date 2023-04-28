import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Icons/icons.dart';
import 'package:flutter_wallpaper_x/ViewModel/BusinessLogic/Repository/repository.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/LocalizationFunctions/localization.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Navigation/navigation.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/favorite.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/setting.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/top_wallpapers.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/wallpaper_detail.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/ThemeFunctions/theme.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Toast/toast.dart';
import 'package:flutter_wallpaper_x/ViewModel/RequestPackage/request_package.dart';
import 'package:get/get.dart';

class DuplicateController extends GetxController {
  // API configuration
  final RequestPackage requestPackage = RequestPackage();
  late Repository repository = Repository(requestPackage);
  // Duplicate tools

  // Top Wallpapers tools
  final TopWallpapersFunctions topWallpapersFunctions =
      TopWallpapersFunctions();
  // Search screen tools

  final GlobalKey<FormState> searchFormKey = GlobalKey();
  final RestorableTextEditingController searchTextController =
      RestorableTextEditingController();
  final String searchResorationId = "WallpapersZ_Search_Screen";

  // Favorite screen tools
  final FavoriteFunctions favoriteFunctions = FavoriteFunctions();

  //  Wallpaper detail screen tools
  final WallpaperDetailNavigation wallpaperDetailNavigation =
      WallpaperDetailNavigation();
  final WallpaperDetailFunctions wpDetailFunctions = WallpaperDetailFunctions();
  // Category collection screen tools
  final CategoryCollectionNavigation categoryCollectionNavigation =
      CategoryCollectionNavigation();

  // Collection wallpapers screen tools
  final CollectionWallpapersNavigation collectionWPsNavigation =
      CollectionWallpapersNavigation();

  //  Top wallpapers screen tools
  final TopWallpapersNavigation topWPsNavigation = TopWallpapersNavigation();

  // Theme selection screen tools
  final ThemeSelectionNavigation themeSelectionNavigation =
      ThemeSelectionNavigation();
  final ThemeFunctions themeFunctions = ThemeFunctions();

  // Language screen tools
  final LanguageSelectionNavigation languageSelectionNavigation =
      LanguageSelectionNavigation();
  final LocalizationFunctions localizationFunctions = LocalizationFunctions();

  // Setting screen tools
  final SettingScreenFunctions settingFunctions = SettingScreenFunctions();

  // Toast tools
  final CustomToast customToast = CustomToast();

  // Custom icons
  final CustomIcons customIcons = CustomIcons();
}
